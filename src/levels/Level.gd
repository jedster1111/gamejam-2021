extends Node2D

class_name Level

signal combo_increased
signal combo_broken
signal next_level_selected


var PauseMenu = preload("res://src/ui/PauseMenu.tscn")
var LevelMenu = preload("res://src/ui/LevelComplete.tscn")
var GameOverMenu = preload("res://src/ui/GameOver.tscn")

const combo_timeout = 3

onready var player = get_node("Player")
onready var finish = get_node("Finish")
onready var combo_timer = Timer.new()

func _ready():
	combo_timer.connect("timeout", self, "break_combo")
	add_child(combo_timer)

	if finish:
		finish.connect("level_complete", self, "create_level_menu")

	player.connect("player_mode_changed", self, "_handle_player_mode_changed")

func _handle_player_mode_changed(mode):
	print("player mode changed", mode)
	match mode:
		player.Modes.FOLLOW_THROUGH:
			increase_combo()
		player.Modes.IDLE:
			break_combo()
		player.Modes.DEAD:
			create_game_over_menu()
		

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
	level_menu.connect("next_level_selected", self, "_handle_level_changed")
	add_child(level_menu)

func create_game_over_menu():
	get_tree().paused = true
	var game_over_menu = GameOverMenu.instance()
	#level_menu.connect("pause_menu_closed", self, "close_pause_menu")
	add_child(game_over_menu)

func increase_combo():
	emit_signal("combo_increased")
	combo_timer.start(combo_timeout)

func break_combo():
	emit_signal("combo_broken")

func _handle_level_changed():
	emit_signal("next_level_selected")

func _on_Enemy_shoot(bullet):
  add_child(bullet)
