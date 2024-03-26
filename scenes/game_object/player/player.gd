extends CharacterBody2D

const SPEED = 170.0
const GRAVITY = 2200.0
const JUMP_VELOCITY = -600.0

@onready var animation_player = $AnimationPlayer

func _ready():
	pass

func _process(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta #APPLY GRAVITY
	else:
		if Input.is_action_pressed("jump"):
			jump()
	
	var direction = get_direction()
	
	if direction == 0:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, 3000 * delta) #HIGH FRICTION
		else: 
			velocity.x = move_toward(velocity.x, 0, SPEED * 2 * delta) #LOW FRICTION
	else:
		velocity.x = direction * SPEED
	
	move_and_slide()
	
	set_animation(direction)

func get_direction():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return x_movement


func set_animation(direction):
	if direction == 0:
		animation_player.play("stand")
	else:
		if direction == -1:
			$Sprite2D.flip_h = 1
		else:
			$Sprite2D.flip_h = 0
		animation_player.play("walk")
	if !is_on_floor():
		animation_player.play("jump")


func jump():
	if is_on_floor():
		velocity.y += JUMP_VELOCITY
