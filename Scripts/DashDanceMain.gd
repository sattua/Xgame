extends Node2D

const Routes = preload("res://Scripts/Routes.gd")
const Globals = preload("res://Scripts/Globals.gd")
@onready var ObstacleScene = preload("res://Scenes/Obstacle.tscn")
@onready var BossScene = preload("res://Scenes/Boss.tscn")

enum LevelPhase { ROUTE1, BOSS1, ROUTE2, FINAL_BOSS, COMPLETE }

var phase := LevelPhase.ROUTE1
var current_route = []
var current_frame := 0

@onready var spawner_timer := $ObstacleSpawner

func _ready():
	print("Main ready")
	spawner_timer.timeout.connect(_on_ObstacleSpawner_timeout)
	start_route("basic_route")

func start_route(route_name: String):
	current_route = Routes.ROUTES[route_name]
	current_frame = 0
	spawner_timer.start()

func _on_ObstacleSpawner_timeout():
	print("Spawner frame: ", current_frame)
	if current_frame >= current_route.size():
		spawner_timer.stop()

		match phase:
			LevelPhase.ROUTE1:
				phase = LevelPhase.BOSS1
				spawn_boss("Boss1")
			LevelPhase.BOSS1:
				phase = LevelPhase.ROUTE2
				start_route("basic_route")  # Replace with next route if needed
			LevelPhase.ROUTE2:
				phase = LevelPhase.FINAL_BOSS
				spawn_boss("FinalBoss")
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
			obstacle.position = Vector2(Globals.LANES[i], -50)
			if obstacle.has_method("set_type"):
				obstacle.set_type(obstacle_type)
			if obstacle.has_signal("obstacle_hit"):
				obstacle.connect("obstacle_hit", Callable(self, "_on_obstacle_hit"))
			add_child(obstacle)

	current_frame += 1

func spawn_boss(name := "Boss1"):
	print("👹 Spawning boss: ", name)
	var boss = BossScene.instantiate()
	
	boss.position = Vector2(Globals.LANES[1], 100)
	add_child(boss)

func _on_obstacle_hit(player):
	print("❌ Player collided with obstacle!")
