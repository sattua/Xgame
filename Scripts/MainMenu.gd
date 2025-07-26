extends Control

@onready var start_button := $StartButton
const DashDanceScene := preload("res://Scenes/DashDanceMain.tscn")

func _ready():
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	var game_node = get_tree().get_root().get_node("Game")
	for child in game_node.get_children():
		child.queue_free()
	var game_instance = DashDanceScene.instantiate()
	get_tree().get_root().get_node("Game").add_child(game_instance)
