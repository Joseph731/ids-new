extends CharacterBody2D

const MAX_SPEED = 1005.0 #85.0
const GRAVITY = 2200.0
const JUMP_VELOCITY = -400.0

@onready var AnimationPlay = $AnimationPlayer
var aggro: bool = false
var direction = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta #APPLY GRAVITY
		
	if aggro:
		direction = get_direction_to_player().x
	else:
		wander()
		
	velocity.x = direction * MAX_SPEED
	move_and_slide()
	
	set_animation(direction)

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
		AnimationPlay.play("idle")
	else:
		if directionVal > 0:
			$Sprite2D.flip_h = 1
		else:
			$Sprite2D.flip_h = 0
		AnimationPlay.play("walk")
	if !is_on_floor():
		AnimationPlay.play("jump")

func wander():
	if direction == 0:
		direction = -1
	if is_on_wall():
		direction = -direction

func on_timeout():
	velocity.x = -velocity.x
