extends CanvasLayer

signal next_level_selected
signal level_restarted

var is_last_level = false
var score = 0

onready var ScoreCounter = get_node("MarginContainer/CenterContainer/VBoxContainer/ScoreCounter")
onready var NextLevel = get_node("MarginContainer/CenterContainer/VBoxContainer/NextLevel")

func _ready():
	NextLevel.disabled = is_last_level
	ScoreCounter.set_score(score)

func _on_NextLevel_pressed():
	emit_signal("next_level_selected")

func _on_Replay_pressed():
	emit_signal("level_restarted")

func _on_Quit_pressed():
	var _success = get_tree().change_scene("res://src/ui/StartScreen.tscn")
