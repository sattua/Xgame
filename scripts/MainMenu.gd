#extends Node
extends Control

signal start_game

@onready var start_button = $StartButton

func _ready():
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	$MainMenuSong.play()
	start_game.emit()
