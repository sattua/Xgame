extends AnimatedSprite2D

const LANE_POSITIONS = [200.0, 400.0, 600.0]
const JUMP_HEIGHT = 50.0
const JUMP_DURATION = 0.5
const MOVE_SPEED = 400.0

var lane := 1
var is_jumping := false
var jump_time := 0.0
var start_y := 0.0
var target_x := 0.0

func _ready():
	start_y = position.y
	target_x = LANE_POSITIONS[lane]
	position.x = target_x
	update_sprite_pose()
	play()  # Inicia animación

func _process(delta):
	# Movimiento suave horizontal
	if abs(position.x - target_x) > 1.0:
		position.x = lerp(position.x, target_x, delta * 10.0)
	else:
		position.x = target_x

	# Salto vertical
	if is_jumping:
		jump_time += delta
		var t = jump_time / JUMP_DURATION
		if t < 1.0:
			position.y = start_y - JUMP_HEIGHT * sin(PI * t)
		else:
			is_jumping = false
			position.y = start_y
			update_sprite_pose()

func move_left():
	if lane > 0:
		lane -= 1
		target_x = LANE_POSITIONS[lane]
		update_sprite_pose()

func move_right():
	if lane < 2:
		lane += 1
		target_x = LANE_POSITIONS[lane]
		update_sprite_pose()

func jump():
	if not is_jumping:
		is_jumping = true
		jump_time = 0.0
		update_sprite_pose()

func update_sprite_pose():
	var pose = ""
	if is_jumping:
		pose = "jump_"
	else:
		pose = "ski_"

	match lane:
		0:
			animation = pose + "left"
		1:
			animation = pose + "center"
		2:
			animation = pose + "right"

	play()
