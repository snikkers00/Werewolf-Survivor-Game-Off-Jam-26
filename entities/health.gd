class_name Health extends Node

signal death

@export var health: int = 1:
	set(value):
		health = value
		if health <= 0:
			death.emit()


func damage(amount: int) -> void:
	health -= amount
