extends Node2D

class_name Level

signal combo_increased
signal combo_broken
signal next_level_selected
signal points_earned
signal combo_timer_updated(perc)
signal level_restarted


var PauseMenu = preload("res://src/ui/PauseMenu.tscn")
var LevelComplete = preload("res://src/ui/LevelComplete.tscn")
var GameOverMenu = preload("res://src/ui/GameOver.tscn")
var Player = preload("res://src/actors/Player.tscn")

var current_combo = 1
var is_last_level = false

onready var start_position = Vector2()

onready var player = Player.instance()

onready var start = get_node("Start")
onready var finish = get_node("Finish")

onready var slashable_nodes = get_tree().get_nodes_in_group("slashable")
onready var enemy_nodes = get_tree().get_nodes_in_group("enemies")
onready var combo_timer = Timer.new()

func _ready():
	combo_timer.connect("timeout", self, "break_combo")
	add_child(combo_timer)
	combo_timer.one_shot = true
	if finish:
		finish.connect("level_complete", self, "create_level_menu")

	player.connect("player_mode_changed", self, "_handle_player_mode_changed")
	player.position = start.position
	player.rotation = start.rotation - PI/2
	add_child(player)
	
	for slashable in slashable_nodes:
		slashable.connect("points_earned", self, "on_point_earned")

	for enemy in enemy_nodes:
		enemy.connect("shoot", self, "_on_Enemy_shoot")
	
func _set_player_start_position(p):
	p.position = start_position

func _on_Enemy_shoot(bullet):
	add_child(bullet)

func on_point_earned(points):
	emit_signal("points_earned", points)

func _handle_player_mode_changed(mode):
	match mode:
		player.Modes.FOLLOW_THROUGH:
			increase_combo()
		player.Modes.DEAD:
			create_game_over_menu()
		

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		create_pause_menu()
		
func _physics_process(_delta):
	var perc = combo_timer.time_left/combo_timer.wait_time * 100
	emit_signal("combo_timer_updated", perc)

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
	var level_complete = LevelComplete.instance()
	level_complete.is_last_level = is_last_level
	level_complete.connect("next_level_selected", self, "_handle_level_changed")
	add_child(level_complete)

func create_game_over_menu():
	get_tree().paused = true
	var game_over_menu = GameOverMenu.instance()
	game_over_menu.connect("level_restarted", self, "_handle_level_restarted")
	add_child(game_over_menu)

func increase_combo():
	emit_signal("combo_increased")
	combo_timer.start(1/current_combo + 0.5)
	
func break_combo():
	emit_signal("combo_broken")

func _handle_level_changed():
	emit_signal("next_level_selected")

func _handle_level_restarted():
	emit_signal("level_restarted")
