extends Area2D

@export var speed := 300.0
@export var direction := Vector2.DOWN

func _physics_process(delta):
	position += direction * speed * delta
	if position.y > 800:
		queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		if body.has_method("take_damage"):
			body.take_damage()
		queue_free()
