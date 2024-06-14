extends CharacterBody2D

signal swung

const SPEED = 170.0
const GRAVITY = 2200.0
const JUMP_VELOCITY = -600.0

@onready var animation_player = $AnimationPlayer
@onready var body = $CompositeSprites/Body
@onready var top = $CompositeSprites/Top
@onready var bottom = $CompositeSprites/Bottom
@onready var footwear = $CompositeSprites/Footwear
@onready var weapon = $CompositeSprites/Weapon
@onready var arm = $CompositeSprites/Arm
@onready var head = $CompositeSprites/Head
@onready var face = $CompositeSprites/Face
@onready var hair_under = $CompositeSprites/HairUnder
@onready var hair_over = $CompositeSprites/HairOver
@onready var right_hand = $CompositeSprites/RightHand
@onready var left_hand = $CompositeSprites/LeftHand
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
			velocity.x = move_toward(velocity.x, 0, 350 * delta) #LOW FRICTION
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
				set_composite_sprites_flip_h(false)
			else:
				set_composite_sprites_flip_h(true)
			animation_player.play("walk")
			
		if !is_on_floor():
			animation_player.play("jump")
			
	else:
		animation_player.play("swing1")


func set_composite_sprites_flip_h(boolVal: bool):
	body.flip_h = boolVal
	top.flip_h = boolVal
	bottom.flip_h = boolVal
	footwear.flip_h = boolVal
	weapon.flip_h = boolVal
	arm.flip_h = boolVal
	head.flip_h = boolVal
	face.flip_h = boolVal
	hair_under.flip_h = boolVal
	hair_over.flip_h = boolVal
	right_hand.flip_h = boolVal
	left_hand.flip_h = boolVal


func jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY


func finished_attack():
	attacking = false

func hurt(enemy_x_pos):
	print($PlayerHealthComponent.current_health)
	if is_on_floor():
		velocity.y = -220
	if (enemy_x_pos < global_position.x):
		velocity.x += 190
			
	else:
		velocity.x -= 190


func on_died():
	pass
