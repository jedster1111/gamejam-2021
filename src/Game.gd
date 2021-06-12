extends Node2D

var combo = 1
var score = 0

onready var inGameUi = get_node("InGameUI")


var current_level = 0
var levels = ["level-1", "Justin_test_scene"]
var level

func _ready():
	var loaded_level_resource = load("res://src/levels/" + levels[current_level] + ".tscn")
	level = loaded_level_resource.instance()
	_set_up_level()

func _on_next_level_selected():
	current_level += 1
	var next_level_resource = load("res://src/levels/" + levels[current_level] + ".tscn")
	_remove_old_level()
	level = next_level_resource.instance()
	_set_up_level()

func _remove_old_level():
	level.queue_free()

func _set_up_level():
	level.connect("combo_increased", self, "on_combo_increased")
	level.connect("combo_broken", self, "on_combo_broken")
	level.connect("next_level_selected", self, "_on_next_level_selected")
	level.connect("points_earned", self, "score_calc")
	reset_state()
	add_child(level)

func on_combo_increased():
	combo += 1
	inGameUi.set_combo(combo)

func on_combo_broken():
	combo = 1
	inGameUi.set_combo(combo)

func score_calc(points):
	score += combo * points
	inGameUi.set_score(score)

func reset_state():
	combo = 1
	score = 0
	inGameUi.set_combo(combo)
	inGameUi.set_score(score)
