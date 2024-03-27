extends Node

signal slime_killed(number: float)

func emit_slime_killed(number: float):
	slime_killed.emit(number)
