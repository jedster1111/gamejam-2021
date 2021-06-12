extends CanvasLayer

onready var combo_counter = get_node("MarginContainer/HBoxContainer/ComboCounter")

func set_combo(new_combo):
	print(combo_counter)
	combo_counter.set_combo(new_combo)
