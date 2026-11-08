class_name Health extends Node

signal death

@export var max_health: int

@export var health: int = 1:
	set(starting_health):
		health = starting_health
		if health <= 0:
			death.emit()


func damage(amount: int) -> void:
	health -= amount
