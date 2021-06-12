extends KinematicBody2D

var velocity = Vector2(1000, 0)

func _ready():
	rotation =  velocity.angle()

func _physics_process(_delta):
	move_bullet()
	
func move_bullet():
	var collision = move_and_collide(velocity * get_physics_process_delta_time() * -0.07)
	if collision:
		queue_free()

	return collision
