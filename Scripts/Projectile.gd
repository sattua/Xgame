extends Area2D
const GLOBALS = preload("res://Scripts/Globals.gd")
@export var speed := 300.0
@export var direction := Vector2.DOWN

func _process(delta):
	var screen_height = get_viewport().get_visible_rect().size.y
	var relative_y = position.y - GLOBALS.HORIZON_Y
	var total_range = screen_height - GLOBALS.HORIZON_Y
	var scale_factor = clamp((relative_y / total_range) * 2.2, 0.07, 0.4)
	scale = Vector2(scale_factor, scale_factor)

func _physics_process(delta):
	position += direction * speed * delta
	if position.y > 800:
		queue_free()
	

func _on_body_entered(body):
	if body.name == "Player" and body.has_method("is_airborne") and not body.is_airborne():
		if body.has_method("take_damage"):
			body.take_damage(1)
		queue_free()
