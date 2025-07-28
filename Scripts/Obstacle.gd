extends Area2D

@onready var player: CharacterBody2D = get_node("/root/Game/Player")  # Optional, see note below

signal obstacle_hit(player)
const Globals = preload("res://Scripts/Globals.gd")
@export var speed: float = 200.0
@export var obstacle_type: String = "trunk"

func _process(delta):
	var screen_height = get_viewport().get_visible_rect().size.y
	var relative_y = position.y - Globals.HORIZON_Y
	var total_range = screen_height - Globals.HORIZON_Y
	var scale_factor = clamp((relative_y / total_range) * 2.2, 0.2, 1.0)

	scale = Vector2(scale_factor, scale_factor)

func _physics_process(delta):
	position.y += speed * delta
	if position.y > 800:
		queue_free()

func set_type(name: String) -> void:
	obstacle_type = name
	# TODO: can change the sprite or visuals based on type here

func _on_body_entered(body: Node) -> void:
	if body.name == "Player" and body.has_method("is_airborne") and not body.is_airborne():
		emit_signal("obstacle_hit", body)

func _on_obstacle_hit(body):
	print("❌ Player collided with obstacle!")
	if body.has_method("take_damage"):
		body.take_damage(1)
