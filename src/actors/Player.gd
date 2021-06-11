extends KinematicBody2D

export var max_dash_distance = 200
export var speed = 1000
var velocity = Vector2(0,0)
var direction = Vector2(0,0)
var start_pos = position

func _physics_process(_delta):
	move_player()

func move_player():
	if Input.is_action_pressed("dash"):
		var mouse_pos = get_viewport().get_mouse_position()
		start_pos = position
		direction = (mouse_pos - position).normalized()
		velocity =  move_and_slide(speed * direction)

	var dash_distance = (position - start_pos).length()
	if dash_distance > max_dash_distance:
		direction = Vector2()
		velocity = Vector2()
	
	velocity =  move_and_slide(velocity)
