extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY =  Vector2(0, 20)
const JUMP_HEIGHT = Vector2(0, -550)

const HOP_RIGHT = Vector2(32, 0)
const HOP_LEFT = Vector2(-32, 0)

var motion = Vector2()

var is_jumping = false
var animation_flag = false
var animation_counter = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	motion += GRAVITY
	
	if animation_flag == true:
		
		animation_counter += delta
		print(animation_counter)
		
		if animation_counter >= 0.5:
			print("exit condition")
			animation_flag = false
		
	else:
	
		if Input.is_action_pressed("ui_right"):
		
			$Sprite.flip_h = false
			$Sprite.play("hop_right")
			animation_flag = true
			motion += HOP_RIGHT
			
		elif Input.is_action_just_pressed("ui_left"):
			
			$Sprite.flip_h = true
			#$Sprite.play("hop_left")
			motion += HOP_LEFT
		
		else:
			
			$Sprite.play('idle')
			motion.x = 0
			
		if Input.is_action_just_pressed("ui_accept"):
			pass
			
		if is_on_floor():
			
			motion.y = 0
			
			if Input.is_action_just_pressed("ui_up"):
				
				motion += JUMP_HEIGHT
				
		move_and_slide(motion, UP)
		
		pass
