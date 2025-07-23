extends Node2D

@onready var sky = $Sky/Sky1
@onready var ground = $Ground/Ground1
@onready var speedline = $Ground/speadline1
@onready var speedline2 = $Ground/speadline2
@onready var speedline3 = $Ground/speadline3

@onready var cloud1 = $Sky/Cloud1
const SKY_SCROLL_SPEED = 30.0


const GROUND_SCROLL_SPEED = 200.0
var is_active = true  # ✅ control animation

func _process(delta):
	if not is_active:
		return

	_speed_line_action(speedline, delta)
	_speed_line_action(speedline2, delta)
	_speed_line_action(speedline3, delta)
	
	_scroll_sky(cloud1, SKY_SCROLL_SPEED, delta)

func _scroll_sky(sprite: Sprite2D, speed: float, delta: float):
	if not sprite.texture:
		print("❌ Missing texture on sprite")
		return

	var height = sprite.texture.get_height()
	sprite.position.y -= speed * delta

	if sprite.position.y <= sky.position.y - 150: # 150: buffer or marging ,some space
		sprite.position.y = sky.get_size().y + 25 # 25: buffer or marging ,some space

func _speed_line_action(element: ColorRect, delta: float):
	var speed = GROUND_SCROLL_SPEED
	var ground_top = ground.position.y
	var ground_bottom = ground.position.y + ground.get_size().y
	var elem_height = element.get_size().y

	element.position.y += speed * delta

	if element.position.y > (ground_bottom - elem_height):
		element.position.y = ground_top

func stop_background():
	is_active = false
