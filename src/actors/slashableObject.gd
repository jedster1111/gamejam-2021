extends KinematicBody2D
class_name SlashableBody

signal points_earned(points)

var random_generator = RandomNumberGenerator.new()

var DestructionScene
var audio_stream

var audio_start_point = 0

var points = 100
var max_lives  = 1
var lives = 1

func _init():
	random_generator.randomize()
	DestructionScene = get_destruction_scene()
	audio_stream = get_destruction_sound()

func _ready():
	self.add_to_group("slashable")

func get_destruction_scene():
	return load("res://src/actors/Destruction.tscn")

func get_destruction_sound():
	audio_start_point = 0.4
	return load("res://assets/audio/Door_smash.wav")

func hit(hit_direction: Vector2):
	emit_signal("points_earned", points)
	lives -= 1

	var transormed_hit = transform.xform_inv(hit_direction)

	if lives <= 0:
		die(transormed_hit)

func die(hit):
	var destruction_instance = DestructionScene.instance()
	destruction_instance.position += hit.normalized() * 30
	destruction_instance.rotation = hit.angle()
	destruction_instance.scale *= 1.5

	add_child(destruction_instance)
	destruction_instance.frame = 0
	destruction_instance.play("default")

	var audio_player = AudioStreamPlayer2D.new()
	audio_player.stream = audio_stream
	add_child(audio_player)
	audio_player.play(audio_start_point)
	yield(destruction_instance, "animation_finished")
	destruction_instance.queue_free()

	queue_free()
