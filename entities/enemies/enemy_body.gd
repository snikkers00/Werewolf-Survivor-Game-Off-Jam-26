extends CharacterBody3D

const SPEED = 2
@onready var enemysprite : AnimatedSprite3D = %EnemySprite
@export var enemy_damage : int

func _physics_process(_delta):
	var player_postion : Vector3 = get_tree().get_first_node_in_group("Player").global_position
	if player_postion != null:
		var dir_to_player = global_position.direction_to(player_postion).normalized()
		velocity.x = dir_to_player.x * SPEED
		velocity.z = dir_to_player.z * SPEED
		move_and_slide()
	elif player_postion == null:
		print("player position invalid")
		
	if velocity.x > 0:
		enemysprite.flip_h = true
	
	elif velocity.x < 0:
		enemysprite.flip_h = false
		

func _on_hit(body: Node2D) -> void:
	var target_health = body.get_node_or_null("Health") as Health
	if target_health:
		target_health.damage(enemy_damage)
