extends KinematicBody2D

var BloodSplatter = preload ("res://src/actors/BloodSplatter.tscn")

var max_lives = 1
var lives = 1

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
	queue_free()

