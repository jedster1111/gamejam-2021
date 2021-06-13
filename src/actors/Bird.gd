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

func get_destruction_scene():
	return load("res://src/actors/BloodSplatter.tscn")

func get_destruction_sound():
	audio_start_point = 0.2
	return load("res://assets/audio/blood_splatter.wav")

func _process(_delta):
	update()


	direction = Vector2()
	velocity = Vector2()

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
