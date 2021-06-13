extends CanvasLayer

signal next_level_selected
signal level_restarted

var is_last_level = false
var score = 0
var ninja_grade = "S"
var end_score = 0

onready var NinjaScoreDisplay = get_node("MarginContainer/CenterContainer/VBoxContainer/NinjaScoreDisplay")
onready var ScoreCounter = get_node("MarginContainer/CenterContainer/VBoxContainer/ScoreCounter")
onready var EndScoreCounter = get_node("MarginContainer/CenterContainer/VBoxContainer/EndScoreCounter")

onready var NextLevel = get_node("MarginContainer/CenterContainer/VBoxContainer/NextLevel")

func _ready():
	NextLevel.disabled = is_last_level

	NinjaScoreDisplay.set_score(ninja_grade)
	ScoreCounter.set_score(score)
	EndScoreCounter.set_score(end_score)

func _on_NextLevel_pressed():
	emit_signal("next_level_selected")

func _on_Replay_pressed():
	emit_signal("level_restarted")

func _on_Quit_pressed():
	var _success = get_tree().change_scene("res://src/ui/StartScreen.tscn")
