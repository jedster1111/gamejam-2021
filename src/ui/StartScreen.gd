extends CanvasLayer

func _on_StartGame_pressed():
	var _success = get_tree().change_scene("res://src/Game.tscn")

func _on_Exit_pressed():
	get_tree().quit()
