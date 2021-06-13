extends SlashableBody

#onready var player_detector = get_node("playerDetector")



#var max_lives = 1
#var lives = 1



var scary_spot = null
var hit_pos

var velocity = Vector2.ZERO
var speed = 300
var direction = Vector2(1,0)

var alert = false

func _ready():
	$AnimatedSprite.play("idle")
	points = 500

func _load_destruction_scene():
	DestructionScene = load("res://src/actors/BloodSplatter.tscn")

func _process(_delta):
	update()


	direction = Vector2()
	velocity = Vector2()


#func hit(hit_direction: Vector2):
	
#	max_lives -= 1

#	if max_lives <= 0:
#		die()

#func die():
#	queue_free()


func _physics_process(_delta):
	
	if alert == true and scary_spot:
		
		direction = (position - scary_spot).normalized()
		velocity = speed * direction
		velocity = move_and_slide(velocity)

func _on_PlayerDetector_body_entered(body):
	alert = true
	$AnimatedSprite.play("flying")
	if scary_spot == null:
		scary_spot = body.position
