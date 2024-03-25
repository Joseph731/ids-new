extends CharacterBody2D

const MAX_SPEED = 170.0
const GRAVITY = 2200.0
const JUMP_VELOCITY = -600.0

@onready var AnimationPlay = $AnimationPlayer

func _ready():
	pass

func _process(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta #APPLY GRAVITY
	else:
		if Input.is_action_pressed("jump"):
			velocity.y += JUMP_VELOCITY
	
	var direction = get_direction()
	velocity.x = direction * MAX_SPEED
	
	move_and_slide()
	
	set_animation(direction)

func get_direction():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return x_movement


func set_animation(direction):
	if direction == 0:
		AnimationPlay.play("stand")
	else:
		if direction == -1:
			$Sprite2D.flip_h = 1
		else:
			$Sprite2D.flip_h = 0
		AnimationPlay.play("walk")
	if !is_on_floor():
		AnimationPlay.play("jump")
