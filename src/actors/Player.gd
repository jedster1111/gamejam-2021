extends KinematicBody2D

signal player_mode_changed(mode)

onready var attack_audio = get_node("AttackAudio")
onready var animated_sprite = get_node("AnimatedSprite")
onready var coyote_timer = get_node("CoyoteTimer")

export var max_dash_distance = 200
export var max_follow_through_distance = 150
export var speed = 4000
export var follow_through_speed = 4000
var velocity = Vector2(0,0)
var direction = Vector2(0,0)
var start_pos = position
var current_wall_collision = null

enum Modes {IDLE, DASHING, FOLLOW_THROUGH, DEAD}
enum Floors {GROUND, AIR}

var mode = Modes.IDLE
var current_floor = Floors.GROUND

func _ready():
	animated_sprite.play("idle")
	coyote_timer.connect("timeout", self, "fall_to_death")

func is_dash_away_from_wall(dash_direction: Vector2, wall_normal: Vector2):
	return dash_direction.dot(wall_normal) > 0

func _physics_process(_delta):
	Engine.time_scale = 1

	if mode == Modes.DEAD: return

	if Input.is_action_just_pressed("dash") and mode != Modes.DASHING:
		var mouse_position = get_global_mouse_position()
		var dash_direction = position.direction_to(mouse_position)
		if current_wall_collision and !is_dash_away_from_wall(dash_direction, current_wall_collision.normal): return
			
		start_dash(mouse_position)

	match mode:
		Modes.DASHING:
			var dash_distance = (position - start_pos).length()
			if dash_distance > max_dash_distance:
				end_dash()
			else: move_player()


		Modes.FOLLOW_THROUGH:
			Engine.time_scale = 0.1
			var follow_through_distance = (position - start_pos).length()
			if follow_through_distance > max_follow_through_distance:
				end_follow_through()
			else: move_player()

func fall_to_death():
	print("dead")

func move_player():
	rotation = velocity.angle()
	var collision = move_and_collide(velocity * get_process_delta_time())
	if collision and collision != current_wall_collision:
		start_idle()
		rotation = collision.normal.angle()

	current_wall_collision = collision

func _on_EnemyDetector_body_entered(enemy):
	if mode == Modes.DASHING or mode == Modes.FOLLOW_THROUGH:
		start_follow_through(position)
		enemy.hit(velocity)

func _on_FloorDetector_area_entered(body):
	print("entering: ", body.name)
	coyote_timer.stop()
	current_floor = Floors.GROUND

func _on_FloorDetector_area_exited(body):
	print("exiting: ", body.name)
	current_floor = Floors.AIR

func start_idle():
	if current_floor == Floors.AIR:
		coyote_timer.start()
		
	animated_sprite.play("idle")
	mode = Modes.IDLE
	
	direction = Vector2()
	velocity = Vector2()

	emit_signal("player_mode_changed", Modes.IDLE)

func start_dash(dash_to_position):
	animated_sprite.play("slash")

	mode = Modes.DASHING
	start_pos = position
	direction = (dash_to_position - position).normalized()
	velocity = speed * direction

func end_dash():
	start_idle()

func start_follow_through(enemy_position):
	coyote_timer.stop()
	attack_audio.play()
	mode = Modes.FOLLOW_THROUGH
	start_pos = enemy_position
	velocity = direction * follow_through_speed
	emit_signal("player_mode_changed", Modes.FOLLOW_THROUGH)

func end_follow_through():
	start_idle()

func start_death():
	mode = Modes.DEAD
	animated_sprite.play("death")
	emit_signal("player_mode_changed", Modes.DEAD)

func _on_BulletDetector_body_entered(body):
	if mode == Modes.DASHING or mode == Modes.FOLLOW_THROUGH:
		start_follow_through(position)
	elif mode == Modes.IDLE:
		start_death()
		body.queue_free()



