extends KinematicBody2D
class_name SlashableBody

signal points_earned(points)

var BloodSplatter = preload ("res://src/actors/BloodSplatter.tscn")

var points = 100
var max_lives  = 1
var lives = 1

func _ready():
	self.add_to_group("slashable")

func hit(hit_direction: Vector2):
	var blood = BloodSplatter.instance()
	blood.position += hit_direction.normalized() * 40
	blood.rotation = hit_direction.angle()
	blood.scale *= 1.5
	add_child(blood)
	blood.stop()
	blood.play("default")
	yield(blood, "animation_finished")
	max_lives -= 1

	if max_lives <= 0:
		die()

func die():
	emit_signal("points_earned", points)
	queue_free()
