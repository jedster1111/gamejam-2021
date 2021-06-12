extends CanvasLayer


func _on_NextLevel_pressed():
	print("Replaying this scene: ", str(int(get_tree().current_scene.name) + 1))
	#var _success = get_tree().change_scene("res://src/ui/" + get_tree().current_scene.name + ".tscn")
	get_tree().change_scene("res://src/levels/level-" + str(int(get_tree().current_scene.name) + 1) + ".tscn")


func _on_Replay_pressed():
	pass

func _on_Quit_pressed():
	print("quit")
	var _success = get_tree().change_scene("res://src/ui/StartScreen.tscn")
