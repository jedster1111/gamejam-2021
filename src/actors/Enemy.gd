extends KinematicBody2D

var max_lives = 1
var lives = 1

func hit():
	max_lives -= 1

	if max_lives <= 0:
		die()

func die():
	queue_free()

