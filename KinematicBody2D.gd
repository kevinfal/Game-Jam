"""

PROBLEMS / TO DO:
	You can levitate in the air by just holding left or right
	Clean up some code, add helper functions and stuff, reorganize things
	Press shinft to see how far I got on stretching, I have some ideas i'll fill you in on
"""


extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY =  Vector2(0, 20)
const JUMP_HEIGHT = Vector2(100, -550) #changed jump arbritrarily

const HOP_RIGHT = Vector2(100, 0) # I changed left and right to 100 arbritrarily
const HOP_LEFT = Vector2(-100, 0)

var motion = Vector2()

var facing_right = true
var is_jumping = false
var hop_flag = false
var animation_counter = 0

var stretching = false
var mass = 2

# gets the children nodes
# gets the animation node for animations
onready var anim = get_node("sprite/AnimationPlayer")
onready var cam = get_node("Camera2D")
onready var sprite = get_node("sprite")
onready var stretched_sprite = get_node("streched")

#camera vars
var normal_zoom = Vector2(1,1)
var zoomed = Vector2(.5,.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	
	print(cam.zoom)
	
	if hop_flag == true:
		
		# counts the frames of animation
		animation_counter += delta
		
		if anim.current_animation == "char_stretching":
			pass
		
		# if enough time has elaped to finish the animation,
		# then stop the animation and play idle (which doesn't
		# really work)
		if animation_counter >= anim.current_animation_length:
			hop_flag = false
			animation_counter = 0
			anim.stop()
	else:
		if stretching:
			cam.zoom = zoomed
			sprite.hide()
			stretched_sprite.show()
			
		else:
			cam.zoom = normal_zoom
			sprite.show()
			stretched_sprite.hide()
			
	motion += GRAVITY
	# check if hopping (moving left or right)
	
		
	if Input.is_key_pressed(KEY_SHIFT):
		stretching = true
		anim.play("char_stretch")
		hop_flag = true
	else:
		stretching = false
		
	
	# input is right arrow
	if Input.is_action_pressed("ui_right"):
		# play the animation for hopping right
		# move right, set facing to right, and play animation
		
		anim.play("hop_right")
		hop_flag = true
		motion = HOP_RIGHT
		facing_right = true
		
		
	elif Input.is_action_pressed("ui_left"):
		
		anim.play("hop_left")
		hop_flag = true
		motion = HOP_LEFT
		facing_right = false

	
	else:
		#choose which direction to play idle for
		if facing_right:
			anim.play("idle")
		else:
			anim.play("idle_left")
		motion.x = 0
		
	if Input.is_action_just_pressed("ui_accept"):
		pass
		
	if is_on_floor():
		
		motion.y = 0
		if Input.is_action_just_pressed("ui_up"):
			motion = JUMP_HEIGHT
		
	move_and_slide(motion, UP)
	
	pass
		
func stretch():
	anim.play("char_strech")
