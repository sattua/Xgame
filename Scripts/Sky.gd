extends Node2D

@export var cloud_nodes: Array[NodePath] = [
	"Cloud",
	"Cloud2"
]

@export var speed := 5.0  # pixels per second
@export var top_limit := -320  # Y-position to wrap clouds to bottom

func _process(delta):
	for path in cloud_nodes:
		var cloud = get_node(path)
		cloud.position.y -= speed * delta  # move up

		if cloud.position.y < top_limit:
			# wrap to bottom of screen
			cloud.position.y = get_viewport_rect().size.y + cloud.texture.get_height()
