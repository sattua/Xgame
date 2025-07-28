extends Node2D

signal boss_finished
@onready var ProjectileScene = preload("res://Scenes/Projectile.tscn")
@export var projectile_limit := 5
@export var move_speed := 100.0
@export var movement_distance := 150.0  # pixels from center

@onready var shoot_timer := $ShootTimer
@onready var entry_timer := $EntryTimer
@onready var sprite := $Sprite

const Globals = preload("res://Scripts/Globals.gd")
const Routes = preload("res://Scripts/Routes.gd")

var current_projectile_route = Routes.BOSS_ROUTES["boss_route_1"]
var projectile_frame := 0

var direction := 1
var projectiles_fired := 0
var center_x := 0.0

func _ready():
	center_x = position.x
	sprite.play("default")
	entry_timer.start()

func _physics_process(delta):
	if shoot_timer.is_stopped():
		return  # Not moving until ready
	
	# Horizontal ping-pong movement
	position.x += direction * move_speed * delta
	
	if abs(position.x - center_x) > movement_distance:
		direction *= -1  # Reverse direction

func _on_entry_timer_timeout() -> void:
	sprite.play("attack")
	shoot_timer.start()

func _on_shoot_timer_timeout() -> void:
	if projectile_frame >= current_projectile_route.size():
		shoot_timer.stop()
		emit_signal("boss_finished")
		queue_free()
		return

	var frame = current_projectile_route[projectile_frame]

	if frame.line1:
		var p1 = ProjectileScene.instantiate()
		p1.position = Vector2(Globals.LANES[0], position.y + 20)
		get_parent().add_child(p1)

	if frame.line2:
		var p2 = ProjectileScene.instantiate()
		p2.position = Vector2(Globals.LANES[1], position.y + 20)
		get_parent().add_child(p2)

	if frame.line3:
		var p3 = ProjectileScene.instantiate()
		p3.position = Vector2(Globals.LANES[2], position.y + 20)
		get_parent().add_child(p3)

	projectile_frame += 1
