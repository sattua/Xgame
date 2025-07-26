extends Area2D

@export var speed := 300.0
@export var direction := Vector2.DOWN
func _ready():
	position = Vector2(240, 100) 
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
func _physics_process(delta):
	position.y += speed * delta
	if position.y > 800:  # off screen
		queue_free()
