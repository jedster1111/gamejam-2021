extends Node2D

class_name Level

signal combo_increased

var PauseMenu = preload("res://src/ui/PauseMenu.tscn")
var LevelMenu = preload("res://src/ui/LevelComplete.tscn")

onready var player = get_node("Player")

func _ready():
	if $Finish:
		$Finish.connect("levelcomplete", self, "create_level_menu")

	player.connect("player_dashed", self, "increase_combo")

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		create_pause_menu()

func _exit_tree():
	get_tree().paused = false

func create_pause_menu():
	get_tree().paused = true
	var pause_menu = PauseMenu.instance()
	pause_menu.connect("pause_menu_closed", self, "close_pause_menu")
	add_child(pause_menu)

func close_pause_menu():
	get_tree().paused = false
	
func create_level_menu():
	get_tree().paused = true
	var level_menu = LevelMenu.instance()
	#level_menu.connect("pause_menu_closed", self, "close_pause_menu")
	add_child(level_menu)

func increase_combo():
	emit_signal("combo_increased")

func _on_Enemy_shoot(bullet):
  add_child(bullet)
