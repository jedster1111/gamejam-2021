extends MarginContainer

onready var combo_value = get_node("CenterContainer/HBoxContainer/ComboValue")

func set_combo(new_value):
	combo_value.text = String(new_value)
