extends ParallaxBackground

@onready var sky1 = $Sky/Sky1
@onready var sky2 = $Sky/Sky2
@onready var ground1 = $Ground/Ground1
@onready var ground2 = $Ground/Ground2

const SKY_SCROLL_SPEED = 20.0
const GROUND_SCROLL_SPEED = 100.0

func _process(delta):
	_scroll_layer(sky1, sky2, SKY_SCROLL_SPEED, delta)
	_scroll_layer(ground1, ground2, GROUND_SCROLL_SPEED, delta)

func _scroll_layer(sprite1: Sprite2D, sprite2: Sprite2D, speed: float, delta: float):
	if not sprite1.texture:
		print("❌ Texture is missing on sprite1!")
		return

	var height = sprite1.texture.get_height()

	sprite1.position.y += speed * delta
	sprite2.position.y += speed * delta

	if sprite1.position.y >= height:
		sprite1.position.y = sprite2.position.y - height
	if sprite2.position.y >= height:
		sprite2.position.y = sprite1.position.y - height
