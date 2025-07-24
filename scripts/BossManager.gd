extends Node2D

var current_boss: Node2D = null

# Preload the boss scenes you might use
const BOSS_YETI := preload("res://scenes/BossYeti.tscn")
# const BOSS_DRAGON := preload("res://scenes/BossDragon.tscn")  # For future bosses

func spawn_boss(name: String, position: Vector2):
	# Remove current boss if any
	if current_boss:
		current_boss.queue_free()
		current_boss = null

	# Choose which boss to load
	var boss_scene: PackedScene
	match name:
		"yeti":
			boss_scene = BOSS_YETI
		# "dragon":
		# 	boss_scene = BOSS_DRAGON
		_:
			print("Unknown boss type: ", name)
			return

	# Instantiate and add new boss
	current_boss = boss_scene.instantiate()
	add_child(current_boss)
	current_boss.position = position

	# Optionally start boss logic
	if current_boss.has_method("start"):
		current_boss.start()
