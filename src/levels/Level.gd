extends Node2D

class_name Level

var PauseMenu = preload("res://src/ui/PauseMenu.tscn") 

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		print("pause")
		add_child(PauseMenu.instance())

func _on_Enemy_shoot(bullet):
  add_child(bullet)
