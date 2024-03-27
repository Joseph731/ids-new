extends CharacterBody2D

signal swung

const SPEED = 170.0
const GRAVITY = 2200.0
const JUMP_VELOCITY = -600.0

@onready var animation_player = $AnimationPlayer
var attacking: bool
var direction = 0

func _ready():
	pass

func _process(delta):
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta #APPLY GRAVITY
	
	
	if Input.is_action_pressed("attack") and !attacking:
		attacking = true
		direction = 0
		emit_signal("swung")
	
	if !attacking:
		direction = get_direction()
		if Input.is_action_pressed("jump"):
			jump()
	
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


func set_animation(directionVal):
	if !attacking:
		if directionVal == 0:
			animation_player.play("stand")
		else:
			if directionVal == -1:
				$Sprite2D.flip_h = 1
			else:
				$Sprite2D.flip_h = 0
			animation_player.play("walk")
			
		if !is_on_floor():
			animation_player.play("jump")
			
	else:
		animation_player.play("swing1")


func jump():
	if is_on_floor():
		velocity.y += JUMP_VELOCITY


func finished_attack():
	attacking = false
