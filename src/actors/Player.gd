extends KinematicBody2D

export var max_dash_distance = 200
export var max_follow_through_distance = 150
export var speed = 2000
export var follow_through_speed = 3000
var velocity = Vector2(0,0)
var direction = Vector2(0,0)
var start_pos = position

enum Modes {IDLE, DASHING, FOLLOW_THROUGH}
var mode = Modes.IDLE

func _physics_process(_delta):
	if Input.is_action_just_pressed("dash"):
		start_dash(get_viewport().get_mouse_position())

	match mode:
		Modes.DASHING:
			var dash_distance = (position - start_pos).length()
			if dash_distance > max_dash_distance:
				end_dash()
			move_player()

		Modes.FOLLOW_THROUGH:
			var follow_through_distance = (position - start_pos).length()
			if follow_through_distance > max_follow_through_distance:
				end_follow_through()
			move_player()

func move_player():
	var collision = move_and_collide(velocity * get_process_delta_time())
	if collision: start_idle()

func _on_EnemyDetector_body_entered(enemy):
	if(mode == Modes.DASHING):
		start_follow_through(enemy.position)

func start_idle():
	direction = Vector2()
	velocity = Vector2()

func start_dash(dash_to_position):
	mode = Modes.DASHING
	start_pos = position
	direction = (dash_to_position - position).normalized()
	velocity = speed * direction
	
func end_dash():
	start_idle()

func start_follow_through(start_of_follow_through):
	print("Starting follow through")
	mode = Modes.FOLLOW_THROUGH
	start_pos = start_of_follow_through
	velocity = direction * follow_through_speed

func end_follow_through():
	start_idle()

