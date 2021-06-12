extends MarginContainer

onready var combo_value = get_node("CenterContainer/HBoxContainer/ScoreValue")

func set_score(new_value):
	combo_value.text = String(new_value)
