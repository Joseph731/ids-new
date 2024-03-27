extends Node

var current_experience = 0

func _ready():
	GameEvents.slime_killed.connect(on_slime_killed)

func increment_experience(number: float):
	current_experience += number
	print(current_experience)


func on_slime_killed(number: float):
	increment_experience(number)
	
