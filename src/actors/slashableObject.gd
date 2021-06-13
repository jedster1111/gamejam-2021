extends KinematicBody2D
class_name SlashableBody

signal points_earned(points)

var DestructionScene = load("res://src/actors/BloodSplatter.tscn")
var audio_stream = load("res://assets/audio/Death_2.wav")

var points = 100
var max_lives  = 1
var lives = 1

func _ready():
	self.add_to_group("slashable")

func hit(hit_direction: Vector2):
	emit_signal("points_earned", points)
	max_lives -= 1

	var destruction_instance = DestructionScene.instance()
	destruction_instance.position += hit_direction.normalized() * 40
	destruction_instance.rotation = hit_direction.angle()
	destruction_instance.scale *= 1.5

	add_child(destruction_instance)

	destruction_instance.play("default")
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.stream = audio_stream
	add_child(audio_player)
	audio_player.play()
	yield(destruction_instance, "animation_finished")

	if max_lives <= 0:
		die()

func die():
	queue_free()
