extends Node2D

var combo = 0

onready var inGameUi = get_node("InGameUI")

func _ready():
	var levels = get_tree().get_nodes_in_group("levels")
	
	if levels.size() > 1:
		print("There's more than one level in this scene?")

	if levels.size() == 0:
		print("There are no levels?")

	levels[0].connect("combo_increased", self, "on_combo_increased")
	levels[0].connect("combo_broken", self, "on_combo_broken")

func on_combo_increased():
	combo += 1
	inGameUi.set_combo(combo)

func on_combo_broken():
	combo = 0
	inGameUi.set_combo(combo)


