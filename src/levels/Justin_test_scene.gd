extends Node2D


func _on_Enemy_shoot(bullet):
	add_child(bullet)
