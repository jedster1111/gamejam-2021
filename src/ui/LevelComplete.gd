extends CanvasLayer

signal next_level_selected

var is_last_level = false

onready var NextLevel = get_node("MarginContainer/CenterContainer/VBoxContainer/NextLevel")

func _ready():
	NextLevel.disabled = is_last_level

func _on_NextLevel_pressed():
	emit_signal("next_level_selected")


func _on_Replay_pressed():
	var _replay = get_tree().reload_current_scene()

func _on_Quit_pressed():
	var _success = get_tree().change_scene("res://src/ui/StartScreen.tscn")
