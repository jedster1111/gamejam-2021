extends VBoxContainer

func _ready():
	var levels = global.levels
	for i in range(levels.size()):
		var level = levels[i]
		var button = Button.new()
		button.text = level

		button.connect("pressed", self, "_handle_select_level", [i])

		add_child(button)

func _handle_select_level(level_index):
	global.selected_starting_level = level_index
	print(global.selected_starting_level)
	var _success = get_tree().change_scene("res://src/Game.tscn")
