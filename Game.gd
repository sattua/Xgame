extends Node2D

@onready var MainMenuScene := preload("res://Scenes/MainMenu.tscn")
var main_menu_instance

func _ready():
	main_menu_instance = MainMenuScene.instantiate()
	add_child(main_menu_instance)
