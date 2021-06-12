extends KinematicBody2D

#onready var player_detector = get_node("playerDetector")

var max_lives = 1
var lives = 1

var target = null
var hit_pos

func _process(delta):
	update()


func hit(hit_direction: Vector2):
	
	max_lives -= 1

	if max_lives <= 0:
		die()

func die():
	queue_free()


func _on_Visibility_body_entered(body):
	if target:
		return
	target = body
	# Debugging purposes
	$coin.self_modulate.r = 0.2



func _on_Visibility_body_exited(body):
	if body == target:
		target = null
	# Debugging purposes
	$coin.self_modulate.r = 1.0



