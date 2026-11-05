extends Node3D
class_name Attack

@export var attack_name : String
@export var cooldown : float

@onready var attack_pivot = $AttackPivot

@onready var collision = %AttackCollision
@onready var sprite = %AttackSprite

func _on_attack_timer_timeout():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var closest_enemy = null
	var shortest_distance = INF
	for e in enemies:
		var distance = global_position.distance_squared_to(e.global_position)
		if distance < shortest_distance:
			shortest_distance = distance
			closest_enemy = e
	
	if closest_enemy != null:
		attack_pivot.look_at(closest_enemy.global_position, Vector3.UP)
		
		collision.disabled = false
		sprite.visible = true
		
		await get_tree().create_timer(0.2).timeout
		disable_attack()
	
func disable_attack():
	collision.disabled = true
	sprite.visible = false
