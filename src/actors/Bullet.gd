extends SlashableBody

var velocity = Vector2(100, 0)

func _ready():
	rotation =  velocity.angle()

func _physics_process(_delta):
	move_bullet()
	
func move_bullet():
	var collision = move_and_collide(velocity * get_physics_process_delta_time())
	if collision:
		queue_free()

	return collision
