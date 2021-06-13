extends Node2D

var combo = 1
var score = 0

onready var inGameUi = get_node("InGameUI")


var current_level = 0
var levels = ["level-1", "Justin_test_scene"]
var level

func _ready():
	_load_level()

func _on_next_level_selected():
	current_level += 1
	_load_level()

func _load_level():
	var level_resource = load("res://src/levels/" + levels[current_level] + ".tscn")
	_remove_old_level()
	level = level_resource.instance()
	_set_up_level()

func _remove_old_level():
	if level and is_instance_valid(level):
		level.queue_free()

func _set_up_level():
	level.connect("combo_increased", self, "on_combo_increased")
	level.connect("combo_broken", self, "on_combo_broken")
	level.connect("next_level_selected", self, "_on_next_level_selected")
	level.connect("points_earned", self, "score_calc")
	level.connect("combo_timer_updated", self, "change_combo_timer_bar")
	level.connect("level_restarted", self, "_on_level_restarted")
	reset_state()
	add_child(level)

func _on_level_restarted():
	print("Level restarted")
	_load_level()

func change_combo_timer_bar(value):
	inGameUi.set_combo_timer(value)

func on_combo_increased():
	combo += 1
	inGameUi.set_combo(combo)
	level.current_combo = combo

func on_combo_broken():
	combo = 1
	inGameUi.set_combo(combo)
	level.current_combo = combo

func score_calc(points):
	score += combo * points
	inGameUi.set_score(score)

func reset_state():
	combo = 1
	score = 0
	inGameUi.set_combo(combo)
	inGameUi.set_score(score)
	level.current_combo = combo
