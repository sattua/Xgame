extends CharacterBody2D

const GRAVITY := 500.0
const LANE_MOVE_SPEED := 9.0
const JUMP_VELOCITY := -200.0
const Globals = preload("res://Scripts/Globals.gd")

var current_lane := 1
var pose_locked := false
var just_jumped := false
var max_hp := 3
var current_hp := max_hp

func _ready():
	position.x = Globals.LANES[current_lane]
	print("Dash Dancer loaded.")

func _physics_process(delta):
	handle_gravity(delta)
	move_and_slide()

	if not pose_locked:
		update_animation()

	pose_locked = false

func _input(event):
	if event.is_action_pressed("move_left") and current_lane > 0:
		current_lane -= 1
		pose_locked = true

	elif event.is_action_pressed("move_right") and current_lane < Globals.LANES.size() - 1:
		current_lane += 1
		pose_locked = true

	elif event.is_action_pressed("jump") and is_on_floor():
		self.velocity.y = JUMP_VELOCITY
		just_jumped = true
		pose_locked = true

func handle_gravity(delta):
	if not is_on_floor():
		self.velocity.y += GRAVITY * delta
	elif just_jumped:
		just_jumped = false
	else:
		self.velocity.y = 0
		
func take_damage():
	current_hp -= 1
	print("💔 Player HP:", current_hp)
	if current_hp <= 0:
		die()
		
func die():
	print("💀 Player defeated!")
	# TODO: Add death animation, sound, or game over screen

func update_animation():
	position.x = lerp(
		position.x,
		Globals.LANES[current_lane],
		LANE_MOVE_SPEED * get_physics_process_delta_time()
	)

	if not is_on_floor():
		if self.velocity.y < 0:
			$AnimatedSprite2D.play("jump_%s" % get_lane_name(current_lane))
		return

	$AnimatedSprite2D.play(get_lane_name(current_lane))

func get_lane_name(index: int) -> String:
	match index:
		0: return "left"
		1: return "center"
		2: return "right"
		_: return "center"  # fallback
		
func is_airborne() -> bool:
	return not is_on_floor()
