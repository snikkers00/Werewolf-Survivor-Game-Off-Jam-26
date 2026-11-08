extends Node3D
class_name Attack

@export var attack_name : String
@export var cooldown : float
@export var damage : int
@export var attack_sprite : Texture2D

@onready var attack_pivot = $AttackPivot

@onready var collision = %AttackCollision
@onready var sprite = %AttackSprite
@onready var attack_timer = %AttackTimer
@onready var attack_area = %AttackArea

func _ready():
	EventsBus.upgrade_selected.connect(apply_attack_upgrade)
	attack_timer.wait_time = cooldown
	attack_area.damage = damage
	sprite.texture = attack_sprite

func _on_attack_timer_timeout():
	sprite.modulate.a = 1.0
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var closest_enemy = null
	var shortest_distance = INF
	for e in enemies:
		var distance = global_position.distance_squared_to(e.global_position)
		if distance < shortest_distance:
			shortest_distance = distance
			closest_enemy = e
	
	if closest_enemy != null:
		var dir_to_enemy = closest_enemy.global_position - attack_pivot.global_position
		dir_to_enemy.y = 0
		var enemy_pos = closest_enemy.global_position
		enemy_pos.y = attack_pivot.global_position.y
		attack_pivot.look_at(enemy_pos, Vector3.UP)
		
		collision.disabled = false
		sprite.visible = true
		
		var fade = create_tween()
		fade.tween_property(sprite, "modulate:a", 0.0 , 0.2)
		await fade.finished

		disable_attack()
	
func disable_attack():
	
	collision.disabled = true
	sprite.visible = false
	

func apply_attack_upgrade(upgrade : Upgrade):
	if upgrade.stat_modified == Upgrade.StatModified.DAMAGE:
		attack_area.damage += int(upgrade.stat_modifier)
	if upgrade.stat_modified == Upgrade.StatModified.ATTACK_SPEED:
		attack_timer.wait_time *= upgrade.stat_modifier
