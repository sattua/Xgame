extends Node2D

const SPEED := 200.0
const IMG_SIZE := 495
const SPRITE_SIZE := Vector2(IMG_SIZE, IMG_SIZE)

@onready var sprite = $Sprite2D

var obstacle_type: String = "rock"  # "rock" or "trunk"
var variant: int = 1                # 1 or 2

func _ready():
	sprite.texture = preload("res://assets/sprites/osbtables.png")
	sprite.region_enabled = true
	sprite.set_process_mode(Node.PROCESS_MODE_ALWAYS)
	sprite.z_index = 100
	sprite.z_as_relative = false 
	sprite.modulate = Color(1, 1, 1, 1)
	sprite.scale = Vector2(0.1, 0.1) 

	var sprite_positions = {
		"rock": [Vector2(0, 0), Vector2(IMG_SIZE, 0)],
		"trunk": [Vector2(0, IMG_SIZE), Vector2(IMG_SIZE, IMG_SIZE)],
	}

	var frames = sprite_positions.get(obstacle_type, [Vector2.ZERO])
	var choice = frames[clamp(variant - 1, 0, frames.size() - 1)]

	sprite.region_rect = Rect2(choice, SPRITE_SIZE)

func _process(delta):
	position.y += SPEED * delta

	if position.y > get_viewport_rect().size.y:
		queue_free()
