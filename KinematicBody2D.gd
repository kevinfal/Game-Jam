"""

PROBLEMS / TO DO:
	
	You can levitate in the air by just holding left or right (fix)
	Clean up some code, add helper functions and stuff, reorganize things
	Press shinft to see how far I got on stretching, I have some ideas i'll fill you in on
	I want everything to sort of pause when you press shift because that's the stretching mode
	fix movement, its like too smooth right now
	Getting rid of redundancy
"""


extends KinematicBody2D

const UNIT = 1000
const UP = Vector2(0, -1)
const GRAVITY =  Vector2(0, 50)
const JUMP_HEIGHT = Vector2(100, -4000) #changed jump arbritrarily
const HOP_RIGHT = Vector2(1000, 0) # I changed left and right to 100 arbritrarily
const HOP_LEFT = Vector2(-1000, 0)

var motion = Vector2()

# flags/booleans
var facing_right = true
var is_jumping = false
var hop_flag = false
var stretch_Flag = false
var void_flag = false # for voiding inputs


# character variables
var mass = 2

# counters
var animation_counter = 0
var void_counter = 0
var time_voided = 0

# gets the children nodes
# gets the animation node for animations
onready var anim = get_node("sprite/AnimationPlayer")
onready var cam = get_node("Camera2D")

# sprite vars
onready var sprite = get_node("sprite") # normal sprite
onready var stretched_sprite = get_node("streched") # the sprite for when the character is stretched

#camera vars
var normal_zoom = Vector2(1,1)
var zoomed = Vector2(.5,.5)

func hopping(delta):
		#this happens every frame of the animation
		animation_counter += delta
		var chop = 15 # UNIT / chop decides how to move every frame
		
		if facing_right:
			var move = ( UNIT / chop )
			movement_x(move)
		# facing left
		elif not facing_right:
			var change = ( -1 * UNIT / chop)
			movement_x(change)
		
		# if animation if finished
		if animation_counter >= anim.current_animation_length :
			
			hop_flag = false
			animation_counter = 0
			anim.stop()
			#motion = HOP_RIGHT
			void_flag = true # ignore inputs after
			time_voided = 0.1 # 0.01 delta
			
func voidInputs(delta):
	"""
		Ignores inputs, has highest priority in controller
	"""
	void_counter += delta
	if void_counter > time_voided:
		time_voided = 0
		void_flag = false
		void_counter = 0
		
func movement_x(change):
	motion = Vector2(change, 0)
	motion += GRAVITY
	move_and_slide(motion,UP)
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	motion = Vector2()
	if void_flag: # ignores inputs
		voidInputs(delta)
	elif hop_flag:
		hopping(delta)
	
	#special controls
	
	#stretching
	if Input.is_key_pressed(KEY_SHIFT):
		stretch_Flag = true
	else:
		# movement controls
		if Input.is_action_pressed("ui_right"):
			# play the animation for hopping right
			# move right, set facing to right, and play animation
			hop_flag = true
			facing_right = true
			anim.play("hop_right")
			hopping(delta)
		elif Input.is_action_pressed("ui_left"):
			hop_flag = true
			facing_right = false
			anim.play("hop_left")
			hopping(delta)
		if Input.is_action_pressed("ui_up") and is_on_floor():
			motion = JUMP_HEIGHT
		# this is for the falling animation
		if not is_on_floor():
			var animation = "fall_right" if facing_right else "fall_left"
			anim.play(animation)
		
		
		
		motion += GRAVITY
		move_and_slide(motion,UP)
func stretch():
	anim.play("char_strech")
