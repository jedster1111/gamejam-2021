extends KinematicBody2D

var velocity = Vector2(1000, 0)
const MAX_BOUNCE = 3
var bounce = 0

func _ready():
	rotation =  velocity.angle()

func _physics_process(_delta):
	move_bullet()
	
func move_bullet():
	var collision = move_and_collide(velocity * get_physics_process_delta_time())

	return collision
