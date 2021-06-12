extends KinematicBody2D

export var max_dash_distance = 200
export var max_follow_through_distance = 150
export var speed = 4000
export var follow_through_speed = 4000
var velocity = Vector2(0,0)
var direction = Vector2(0,0)
var start_pos = position
var current_wall_collision = null

enum Modes {IDLE, DASHING, FOLLOW_THROUGH}
var mode = Modes.IDLE

func is_dash_away_from_wall(dash_direction: Vector2, wall_normal: Vector2):
	return dash_direction.dot(wall_normal) > 0

func _physics_process(_delta):
	if Input.is_action_just_pressed("dash") and mode != Modes.DASHING:
		var mouse_position = get_global_mouse_position()
		var dash_direction = position.direction_to(mouse_position)
		if current_wall_collision and !is_dash_away_from_wall(dash_direction, current_wall_collision.normal): return
			
		start_dash(mouse_position)

	Engine.time_scale = 1
	match mode:
		Modes.DASHING:
			var dash_distance = (position - start_pos).length()
			if dash_distance > max_dash_distance:
				end_dash()
			move_player()

		Modes.FOLLOW_THROUGH:
			Engine.time_scale = 0.1
			var follow_through_distance = (position - start_pos).length()
			if follow_through_distance > max_follow_through_distance:
				end_follow_through()
			move_player()

func move_player():
	rotation = velocity.angle()
	var collision = move_and_collide(velocity * get_process_delta_time())
	if collision and collision != current_wall_collision:
		start_idle()
		rotation = collision.normal.angle()

	current_wall_collision = collision

func _on_EnemyDetector_body_entered(enemy):
	if(mode == Modes.DASHING or mode == Modes.FOLLOW_THROUGH):
		start_follow_through(enemy.position)
		enemy.hit()

func start_idle():
	mode = Modes.IDLE
	direction = Vector2()
	velocity = Vector2()

func start_dash(dash_to_position):
	mode = Modes.DASHING
	start_pos = position
	direction = (dash_to_position - position).normalized()
	velocity = speed * direction
	
func end_dash():
	start_idle()

func start_follow_through(follow_through_start_position):
	mode = Modes.FOLLOW_THROUGH
	start_pos = follow_through_start_position
	velocity = direction * follow_through_speed

func end_follow_through():
	start_idle()

