extends Area2D

@onready var player: CharacterBody2D = get_node("/root/Game/Player")  # Optional, see note below

signal obstacle_hit(player)

@export var speed: float = 200.0
@export var obstacle_type: String = "trunk"

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

func _on_obstacle_hit(player):
	print("❌ Player collided with obstacle!")
	if player.has_method("take_damage"):
		player.take_damage()
