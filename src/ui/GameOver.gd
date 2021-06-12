extends CanvasLayer

func _on_Replay_pressed():
	get_tree().reload_current_scene()


func _on_Quit_pressed():
	var _success = get_tree().change_scene("res://src/ui/StartScreen.tscn")
