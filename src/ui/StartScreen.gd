extends CanvasLayer

onready var MainMenu = get_node("MarginContainer/CenterContainer/Main")
onready var LevelSelectMenu = get_node("MarginContainer/CenterContainer/LevelSelect")

func _on_StartGame_pressed():
	MainMenu.visible = false
	LevelSelectMenu.visible = true

func _on_Exit_pressed():
	get_tree().quit()
