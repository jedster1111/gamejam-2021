extends KinematicBody2D
class_name SlashableBody

signal points_earned(points)

var DestructionScene
var audio_stream = preload("res://assets/audio/Death_2.wav")

var points = 100
var max_lives  = 1
var lives = 1

func _init():
	_load_destruction_scene()

func _ready():
	self.add_to_group("slashable")

func _load_destruction_scene():
	DestructionScene = load("res://src/actors/Destruction.tscn")
func hit(hit_direction: Vector2):
	emit_signal("points_earned", points)
	max_lives -= 1

	var transormed_hit = transform.xform_inv(hit_direction)

	var destruction_instance = DestructionScene.instance()
	destruction_instance.position += transormed_hit.normalized() * 30
	destruction_instance.rotation = transormed_hit.angle()
	destruction_instance.scale *= 1.5

	add_child(destruction_instance)
	destruction_instance.frame = 0
	destruction_instance.play("default")

	var audio_player = AudioStreamPlayer2D.new()
	audio_player.stream = audio_stream
	add_child(audio_player)
	audio_player.play()
	yield(destruction_instance, "animation_finished")
	destruction_instance.queue_free()

	if max_lives <= 0:
		die()

func die():
	queue_free()
