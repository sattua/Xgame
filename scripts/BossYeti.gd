extends Node2D

@onready var animation = $BossSprite

const SPEED = 60.0
func _ready():
	animation.z_index = 10
	animation.play("walk")
	
func show_yeti():
	animation.visible = true
	animation.play("walk")
	
func hide_yeti():
	animation.visible = false
	animation.stop()
