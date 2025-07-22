extends Sprite2D

const LANE_POSITIONS = [200.0, 400.0, 600.0]
const JUMP_HEIGHT = 50.0
const JUMP_DURATION = 0.5

var lane := 1
var is_jumping := false
var jump_time := 0.0
var start_y := 0.0

func _ready():
	start_y = position.y
	position.x = LANE_POSITIONS[lane]
	update_sprite_pose()

func _process(delta):
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
		position.x = LANE_POSITIONS[lane]
		update_sprite_pose()

func move_right():
	if lane < 2:
		lane += 1
		position.x = LANE_POSITIONS[lane]
		update_sprite_pose()

func jump():
	if not is_jumping:
		is_jumping = true
		jump_time = 0.0
		update_sprite_pose()

func update_sprite_pose():
	var region := Rect2()

	if is_jumping:
		match lane:
			0: region = Rect2(0, 620, 600, 600)   # jump left
			1: region = Rect2(980, 620, 600, 600) # jump center
			2: region = Rect2(600, 620, 600, 600) # jump right
	else:
		match lane:
			0: region = Rect2(0, 0, 600, 600)     # move left
			1: region = Rect2(980, 0, 600, 600)   # move center
			2: region = Rect2(600, 0, 600, 600)   # move right

	self.region_rect = region
