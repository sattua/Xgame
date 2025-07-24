extends Node2D

@onready var ObstacleScene = preload("res://scenes/Obstacle.tscn")
@onready var MainMenuScene = preload("res://scenes/MainMenu.tscn")
@onready var BackgroundScene = preload("res://scenes/Background.tscn")

const IMG_SIZE := 495 #duplicated from obstacles.gd
const SPRITE_SIZE := Vector2(IMG_SIZE, IMG_SIZE) #duplicated from obstacles.gd

var MainMenuInstance: Control
@onready var ObstacleContainer = $ObstacleContainer
@onready var Skier = $Skier
@onready var MainMessageLabel = $MainMessageLabel
@onready var Ground = $Background/Ground

var Routes = load("res://scripts/Routes.gd").new()
@onready var route_data = Routes.ROUTES["basic_route"]

var spawn_index = 0
var time_elapsed = 0.0

enum GameState { START, PLAYING, GAME_OVER, IN_MENU }
var state = GameState.START

const LANE_POSITIONS = [200.0, 400.0, 600.0]
const OBSTACLE_SPAWN_INTERVAL := 1.5
const COLLISION_DISTANCE := 20.0
const DIFFICULTY := 3
var spawn_timer := 0.0

var background_instance
var current_boss: Node2D = null

func _ready():
	MainMenuInstance = MainMenuScene.instantiate()
	add_child(MainMenuInstance)

	background_instance = BackgroundScene.instantiate()
	add_child(background_instance)
	move_child(background_instance, 0)

	MainMenuInstance.start_game.connect(on_start_game_from_menu)
	_setGameMode(Node.PROCESS_MODE_WHEN_PAUSED)
	randomize()

func on_start_game_from_menu():
	MainMenuInstance.hide()
	state = GameState.START
	MainMessageLabel.text = "Press Enter to Start"
	MainMessageLabel.show()

func _setGameMode(mode: int):
	set_process_mode(mode)
	Skier.set_process_mode(mode)
	ObstacleContainer.set_process_mode(mode)
	get_tree().paused = Node.PROCESS_MODE_WHEN_PAUSED == mode

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if state == GameState.START:
			start_game()
		elif state == GameState.GAME_OVER:
			restart_game()
		return

	if state != GameState.PLAYING:
		return

	if event.is_action_pressed("move_left"):
		Skier.move_left()
	elif event.is_action_pressed("move_right"):
		Skier.move_right()
	elif event.is_action_pressed("jump"):
		$Skier/SkiSound.stop()
		Skier.jump()
		$Skier/SkiSound.play()

func start_game():
	state = GameState.PLAYING
	$Skier/SkiSound.play()
	init_boss()
	_setGameMode(Node.PROCESS_MODE_ALWAYS)
	MainMenuInstance.hide()
	spawn_timer = 0.0
	print("✅ Start Game")

func init_boss():
	$BossManager.spawn_boss("yeti", Vector2(0, Ground.size.y))

func game_over():
	$Skier/SkiSound.stop()
	$Background.stop_background()
	state = GameState.GAME_OVER
	_setGameMode(Node.PROCESS_MODE_WHEN_PAUSED)
	MainMessageLabel.text = "💀 Game Over! Press Enter to Restart"
	MainMessageLabel.show()
	print("❌ Game Over")
	for obstacle in ObstacleContainer.get_children():
		obstacle.set_process(false)

func restart_game():
	print("restart_game")
	get_tree().reload_current_scene()

func _process(delta):
	if state != GameState.PLAYING:
		return

	spawn_timer += delta
	if spawn_timer >= OBSTACLE_SPAWN_INTERVAL:
		spawn_timer = 0.0
		spawn_route_obstacles()

	for obstacle in ObstacleContainer.get_children():
		var obstacle_pos = obstacle.position
		if obstacle_pos.distance_to(Skier.position) < COLLISION_DISTANCE:
			if not Skier.is_jumping:
				game_over()

# spawn obstacles based on route data
func spawn_route_obstacles():
	if spawn_index >= route_data.size():
		return

	var obstacle_row = route_data[spawn_index]

	for lane in 3:
		var key = "line%d" % (lane + 1)
		var obstacle_type = obstacle_row.get(key, "")
		if obstacle_type != "":
			var obs = ObstacleScene.instantiate()
			obs.obstacle_type = obstacle_type
			obs.variant = 1  # optionally randomize later
			obs.position = Vector2(LANE_POSITIONS[lane], Ground.position.y)
			ObstacleContainer.add_child(obs)

	spawn_index += 1
