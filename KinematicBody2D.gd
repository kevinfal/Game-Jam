extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY =  Vector2(0, 20)
const JUMP_HEIGHT = Vector2(0, -550)

const HOP_RIGHT = Vector2(100, 0)
const HOP_LEFT = Vector2(-100, 0)

var motion = Vector2()

var facing_right = true

var is_jumping = false
var hop_flag = false
var animation_counter = 0

# gets the animation node for animations
onready var anim = get_node("sprite/AnimationPlayer")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	motion += GRAVITY
	# check if hopping (moving left or right)
	if hop_flag == true:
		
		# counts the frames of animation
		animation_counter += delta
		
		# if enough time has elaped to finish the animation,
		# then stop the animation and play idle (which doesn't
		# really work)
		if animation_counter >= anim.current_animation_length:
			hop_flag = false
			animation_counter = 0
			anim.stop()
			
			#choose which direction to play idle for
			if facing_right:
				anim.play("idle")
			else:
				anim.play("idle_left")
	else:
		
		# input is right arrow
		if Input.is_action_pressed("ui_right"):
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
			anim.play("idle")
			motion.x = 0
			
		if Input.is_action_just_pressed("ui_accept"):
			pass
			
		if is_on_floor():
			
			motion.y = 0
			
			if Input.is_action_just_pressed("ui_up"):
				
				motion += JUMP_HEIGHT
				
		move_and_slide(motion, UP)
		
		pass
