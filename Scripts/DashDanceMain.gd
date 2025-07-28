extends Node2D

const Routes = preload("res://Scripts/Routes.gd")
const GLOBALS = preload("res://Scripts/Globals.gd")
@onready var ObstacleScene = preload("res://Scenes/Obstacle.tscn")
@onready var BossScene = preload("res://Scenes/Boss.tscn")

enum LevelPhase { ROUTE1, BOSS1, ROUTE2, FINAL_BOSS, COMPLETE }

var phase := LevelPhase.ROUTE1
var current_route = []
var current_frame := 0

@onready var spawner_timer := $ObstacleSpawner
@onready var speedline_timer := $SpeedLineTimer
@onready var speedline_template := $SpeedLineContainer/SpeedLine
@onready var speedline_container := $SpeedLineContainer

func _ready():
	print("Main ready")
	spawner_timer.timeout.connect(_on_ObstacleSpawner_timeout)
	start_route("route_1")
	speedline_timer.timeout.connect(_on_SpeedLineTimer_timeout)

func start_route(route_name: String):
	current_route = Routes.ROUTES[route_name]
	current_frame = 0
	spawner_timer.start()
	speedline_timer.start()

func _on_ObstacleSpawner_timeout():
	print("Spawner frame: ", current_frame)
	if current_frame >= current_route.size():
		spawner_timer.stop()

		match phase:
			LevelPhase.ROUTE1:
				phase = LevelPhase.BOSS1
				spawn_boss("boss_1")
			LevelPhase.BOSS1:
				phase = LevelPhase.ROUTE2
				start_route("route_2")
			LevelPhase.ROUTE2:
				phase = LevelPhase.FINAL_BOSS
				spawn_boss("boss_2")
			LevelPhase.FINAL_BOSS:
				phase = LevelPhase.COMPLETE
				print("🎉 Level Complete!")
		return

	var frame = current_route[current_frame]
	var lane_keys = ["line1", "line2", "line3"]

	for i in range(3):
		var obstacle_type = frame[lane_keys[i]]
		if obstacle_type != "":
			var obstacle = ObstacleScene.instantiate()
			obstacle.position = Vector2(GLOBALS.LANES[i], GLOBALS.HORIZON_Y)
			if obstacle.has_method("set_type"):
				obstacle.set_type(obstacle_type)
			if obstacle.has_signal("obstacle_hit"):
				obstacle.connect("obstacle_hit", Callable(self, "_on_obstacle_hit"))
			add_child(obstacle)

	current_frame += 1

func spawn_boss(bossname):
	var boss = BossScene.instantiate()
	boss.position = Vector2(GLOBALS.LANES[1], 100)  # Center lane
	boss.set_projectile_route(Routes.BOSS_ROUTES[bossname])
	boss.connect("boss_finished", Callable(self, "_on_boss_finished"))
	add_child(boss)

func _on_boss_finished() -> void:
	match phase:
		LevelPhase.BOSS1:
			phase = LevelPhase.ROUTE2
			start_route("route_2")
		LevelPhase.FINAL_BOSS:
			phase = LevelPhase.COMPLETE
			print("🎉 Level Complete!")
		_:
			print("⚠ Unexpected boss phase")

func _on_obstacle_hit(player) -> void:
	if player.has_method("take_damage"):
			player.take_damage()
			
func _on_SpeedLineTimer_timeout():
	var line = speedline_template.duplicate()
	line.position = Vector2(0, GLOBALS.HORIZON_Y)
	speedline_container.add_child(line)
  
	# Animate the line
	var tween = create_tween()
	tween.tween_property(line, "position:y", 700, 1)  # move down, line,position,position-destination,speed
	tween.tween_property(line, "modulate:a", 0.0, 0.6)
	tween.tween_callback(Callable(line, "queue_free"))
