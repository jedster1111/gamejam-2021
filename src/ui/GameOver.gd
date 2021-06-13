extends CanvasLayer

signal level_restarted

func _on_Replay_pressed():
	emit_signal("level_restarted")

func _on_Quit_pressed():
	var _success = get_tree().change_scene("res://src/ui/StartScreen.tscn")
