extends Node2D

@onready var ObstacleScene = preload("res://Obstacle.tscn")
@onready var ObstacleContainer = $ObstacleContainer
@onready var Skier = $Skier

const LANE_POSITIONS = [200.0, 400.0, 600.0]  # Used for obstacle spawning
const OBSTACLE_SPAWN_INTERVAL := 1.5
const COLLISION_DISTANCE := 40.0
const DIFFICULTY := 3; # add to rules: difficulty 1 easy, 2 mid, 3 hard
var spawn_timer := 0.0
var is_game_over := false

func _ready():
	randomize()

func _input(event):
	if is_game_over:
		return  # disable controls if game is over

	if event.is_action_pressed("move_left"):
		Skier.move_left()
	elif event.is_action_pressed("move_right"):
		Skier.move_right()
	elif event.is_action_pressed("jump"):
		Skier.jump()

func _process(delta):
	if is_game_over:
		return

	# Obstacle spawn timer
	spawn_timer += delta
	if spawn_timer >= OBSTACLE_SPAWN_INTERVAL:
		spawn_timer = 0.0
		spawn_obstacle(DIFFICULTY)

	# Collision detection
	for obstacle in ObstacleContainer.get_children():
		if obstacle.position.distance_to(Skier.position) < COLLISION_DISTANCE:
			if not Skier.is_jumping:
				game_over()

func spawn_obstacle(difficulty: int):
	for i in range(difficulty):
		var obstacle = ObstacleScene.instantiate()
		var lane_x = LANE_POSITIONS[randi() % 3]
		
		obstacle.position = Vector2(lane_x, -50)
		ObstacleContainer.add_child(obstacle)

func game_over():
	is_game_over = true
	print("💀 GAME OVER")
	get_tree().paused = true
