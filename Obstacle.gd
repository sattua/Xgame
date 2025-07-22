extends Node2D

const SPEED := 200.0  # píxeles por segundo

func _process(delta):
	position.y += SPEED * delta
	
	if position.y > get_viewport_rect().size.y:
		queue_free()  # destruir cuando sale de pantalla
