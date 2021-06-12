extends CanvasLayer


func _on_NextLevel_pressed():
	var _change = get_tree().change_scene("res://src/levels/level-" + str(int(get_tree().current_scene.name) + 1) + ".tscn")


func _on_Replay_pressed():
	var _replay = get_tree().reload_current_scene()

func _on_Quit_pressed():
	var _success = get_tree().change_scene("res://src/ui/StartScreen.tscn")
