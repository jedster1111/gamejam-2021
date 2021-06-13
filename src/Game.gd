extends Node2D

var combo = 1
var score = 0
var number_of_combo_breaks = 0
var ninja_grade = "S+"
var end_score = 0

onready var inGameUi = get_node("InGameUI")


var current_level = 0
var levels = ["level-1", "Justin_test_scene"]
var level

func _ready():
	_load_level()
	calculate_scores()
	set_child_values()

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
	level.connect("game_paused", self, "_on_game_paused")
	level.connect("game_unpaused", self, "_on_game_unpaused")

	level.is_last_level = current_level + 1 == levels.size()

	reset_state()
	add_child(level)

func _on_level_restarted():
	print("Level restarted")
	_load_level()

func _on_game_paused():
	print("Pause level")
	get_tree().paused = true
	inGameUi.get_child(0).visible = false

func _on_game_unpaused():
	print("Pause level")
	get_tree().paused = false
	inGameUi.get_child(0).visible = true

func change_combo_timer_bar(value):
	inGameUi.set_combo_timer(value)

func on_combo_increased():
	combo += 1
	set_child_values()

func on_combo_broken():
	combo = 1
	number_of_combo_breaks += 1
	
	calculate_scores()
	set_child_values()

func score_calc(points):
	score += combo * points

	calculate_scores()
	set_child_values()

func calculate_scores():
	calculate_ninja_grade()
	calculate_end_score()

func set_child_values():
	inGameUi.set_combo(combo)
	inGameUi.set_score(score)
	level.current_combo = combo
	level.ninja_grade = ninja_grade
	level.end_score = end_score
	level.current_score = score

func calculate_ninja_grade():
	var result
	match number_of_combo_breaks:
		0: result = "S+"
		1,2: result = "S"
		3,4,5: result = "A"
		6,7,8,9,10: result = "B"
		11,12,13,14: result = "C"
		_: result = "D"

	ninja_grade = result

func calculate_end_score():
	var ninja_bonus_points

	match ninja_grade:
		"S+": ninja_bonus_points = 10000
		"S": ninja_bonus_points = 9000
		"A": ninja_bonus_points = 7000
		"B": ninja_bonus_points = 4000
		"C": ninja_bonus_points = 1000
		_: ninja_bonus_points = 0

	end_score = score + ninja_bonus_points
	
func reset_state():
	combo = 1
	score = 0
	number_of_combo_breaks = 0
	ninja_grade = "S+"
	end_score = 0
	
	set_child_values()
