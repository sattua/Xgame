extends Node2D

@onready var ObstacleScene = preload("res://scenes/Obstacle.tscn")
@onready var MainMenuScene = preload("res://scenes/MainMenu.tscn")
var MainMenuInstance: Control
@onready var ObstacleContainer = $ObstacleContainer
@onready var Skier = $Skier
@onready var MainMessageLabel = $MainMessageLabel
@onready var Ground = $Background/Ground

enum GameState { START, PLAYING, GAME_OVER, IN_MENU }

var state = GameState.START
const LANE_POSITIONS = [200.0, 400.0, 600.0]
const OBSTACLE_SPAWN_INTERVAL := 1.5
const COLLISION_DISTANCE := 20.0
const DIFFICULTY := 3
var spawn_timer := 0.0
@onready var BackgroundScene = preload("res://scenes/Background.tscn")
var background_instance

func _ready():
	MainMenuInstance = MainMenuScene.instantiate()
	add_child(MainMenuInstance)
	
	background_instance = BackgroundScene.instantiate()
	add_child(background_instance)  # add as first child to keep behind everything
	move_child(background_instance, 0)  # ensure it's the first = behind all

	MainMenuInstance.start_game.connect(on_start_game_from_menu)

	_setGameMode(Node.PROCESS_MODE_WHEN_PAUSED)
	randomize()
	
func on_start_game_from_menu():
	MainMenuInstance.hide()
	#$MenuMusic.stop()
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

	if event.is_action_pressed("move_left"): # this si the inputs mapped
		Skier.move_left()
	elif event.is_action_pressed("move_right"):
		Skier.move_right()
	elif event.is_action_pressed("jump"):
		$Skier/SkiSound.stop()
		Skier.jump()
		$Skier/SkiSound.play() # TODO this is not working


func start_game():
	state = GameState.PLAYING
	$Skier/SkiSound.play()
	_setGameMode(Node.PROCESS_MODE_ALWAYS)
	MainMenuInstance.hide()
	spawn_timer = 0.0
	print("✅ Start Game")

func game_over():
	$Skier/SkiSound.stop()
	$Background.stop_background()
	
	state = GameState.GAME_OVER
	_setGameMode(Node.PROCESS_MODE_WHEN_PAUSED)
	MainMessageLabel.text = "💀 Game Over! Press Enter to Restart"
	MainMessageLabel.show()
	print("❌ Game Over")
	# Stop all obstacle movement
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
		spawn_obstacle(DIFFICULTY)

	for obstacle in ObstacleContainer.get_children():
		var obstacle_pos = obstacle.position # collition Areay
		if obstacle_pos.distance_to(Skier.position) < COLLISION_DISTANCE:
			if not Skier.is_jumping:
				game_over()

func spawn_obstacle(difficulty: int):
	for i in range(difficulty):
		var obstacle = ObstacleScene.instantiate()
		var lane_x = LANE_POSITIONS[randi() % 3]
		obstacle.position = Vector2(lane_x, Ground.position.y) # sky heigth
		ObstacleContainer.add_child(obstacle)
