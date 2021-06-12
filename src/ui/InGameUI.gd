extends CanvasLayer

onready var combo_counter = get_node("MarginContainer/HBoxContainer/ComboCounter")
onready var score_counter = get_node("MarginContainer/HBoxContainer/ScoreCounter")

func set_combo(new_combo):
	combo_counter.set_combo(new_combo)

func set_score(new_score):
	score_counter.set_score(new_score)
