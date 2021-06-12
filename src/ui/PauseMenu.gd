extends CanvasLayer

signal pause_menu_closed

func _on_Resume_pressed():
	emit_signal("pause_menu_closed")
	queue_free()

func _on_Exit_pressed():
	var _success = get_tree().change_scene("res://src/ui/StartScreen.tscn")
