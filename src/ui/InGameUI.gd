extends CanvasLayer

onready var combo_counter = get_node("MarginContainer/HBoxContainer/ComboCounter")
onready var score_counter = get_node("MarginContainer/HBoxContainer/ScoreCounter")
onready var combo_timer_bar = get_node("MarginContainer/HBoxContainer/CenterContainer/Combo_timer")

func set_combo(new_combo):
	combo_counter.set_combo(new_combo)

func set_score(new_score):
	score_counter.set_score(new_score)

func set_combo_timer(new_value):
	combo_timer_bar.value = new_value
