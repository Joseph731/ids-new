extends CharacterBody2D

const SPEED = 100.0
const GRAVITY = 2200.0
const JUMP_VELOCITY = -600.0

@onready var animation_player = $AnimationPlayer
@onready var hitbox = $Hitbox
@onready var floor_scanner = $FloorScanner
@onready var wander_timer = $Wander
@onready var rest_timer = $Rest
@onready var turn_timer = $Turn
@onready var jump_timer = $Jump
var aggro: bool = false
var detects_cliffs: bool = true
var direction = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	wander_timer.timeout.connect(on_wander_timeout)
	rest_timer.timeout.connect(on_rest_timeout)
	turn_timer.timeout.connect(on_turn_timeout)
	jump_timer.timeout.connect(on_jump_timeout)
	floor_scanner.position.x = (hitbox.get_shape().size.x / 3) * direction #Dividing by 3 instead of 2 lets the slime go a little over the cliff
	floor_scanner.enabled = detects_cliffs


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta #APPLY GRAVITY
		
	if aggro:
		direction = get_direction_to_player().x
	else:
		wander()
	
	if (detects_cliffs and !floor_scanner.is_colliding()):
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


func wander():
	if is_on_wall():
		switch_direction()
	if wander_timer.is_stopped() and rest_timer.is_stopped():
		wander_timer.start()


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		var direction_to_player = player_node.global_position - global_position
		if direction_to_player.x > 0:
			direction_to_player.x = 1
		elif direction_to_player.x < 0:
			direction_to_player.x = -1
		if direction_to_player.y > 0:
			direction_to_player.y = 1
		elif direction_to_player.y < 0:
			direction_to_player.y = -1
		return direction_to_player
	return Vector2.ZERO


func set_animation(directionVal):
	if directionVal == 0:
		animation_player.play("idle")
	else:
		if directionVal > 0:
			$Sprite2D.flip_h = 1
		else:
			$Sprite2D.flip_h = 0
		animation_player.play("walk")
	if !is_on_floor():
		animation_player.play("jump")


func switch_direction():
	if is_on_floor():
		direction = -direction
		floor_scanner.position.x = (hitbox.get_shape().size.x / 3) * direction


func jump():
	if is_on_floor():
		velocity.y += JUMP_VELOCITY


func on_wander_timeout():
	if !aggro:
		direction = 0
		rest_timer.set_wait_time(randf_range(1.5, 4.0))
		rest_timer.start()


func on_rest_timeout():
	if (randi() % 2 == 0):
		direction = -1
	else:
		direction = 1 
	wander_timer.set_wait_time(randi_range(6, 16))
	wander_timer.start()


func on_turn_timeout():
	if rest_timer.is_stopped():
		switch_direction()
	turn_timer.set_wait_time(randi_range(2, 11))


func on_jump_timeout():
	if rest_timer.is_stopped():
		jump()
	jump_timer.set_wait_time(randi_range(2,10))
