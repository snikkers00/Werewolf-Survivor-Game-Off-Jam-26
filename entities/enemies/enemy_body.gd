extends CharacterBody3D

@onready var health_bar = %HealthBar

@export var SPEED : float = 1
@onready var enemysprite : AnimatedSprite3D = %EnemySprite
@export var enemy_damage : int
@export var enemy_xp_value : int
@onready var health_comp = $Health

@export var is_boss : bool = false

var knockback_velocity : Vector3 = Vector3.ZERO

func _ready():
	health_comp.death.connect(die)
	health_bar.max_value = health_comp.health
	health_bar.value = health_comp.health

func _physics_process(_delta):
	var player_postion : Vector3 = get_tree().get_first_node_in_group("Player").global_position
	if player_postion != null:
		var dir_to_player = global_position.direction_to(player_postion).normalized()
		velocity.x = dir_to_player.x * SPEED + knockback_velocity.x
		velocity.z = dir_to_player.z * SPEED + knockback_velocity.z
		move_and_slide()
		knockback_velocity = knockback_velocity.move_toward(Vector3.ZERO, 20 * _delta)


	elif player_postion == null:
		print("player position invalid")
		
	if velocity.x > 0:
		enemysprite.flip_h = true
	
	elif velocity.x < 0:
		enemysprite.flip_h = false


func die():
	EventsBus.xp_gained.emit(enemy_xp_value)
	RunStats.enemies_killed += 1
	if is_boss == true:
		EventsBus.boss_defeated.emit()
	queue_free()


func _on_enemy_hurtbox_area_entered(area):
	health_comp.damage(area.damage)
	health_bar.value -= area.damage
	var player_postion : Vector3 = get_tree().get_first_node_in_group("Player").global_position
	knockback_velocity = (global_position.direction_to(player_postion) * -1) * 8
	knockback_velocity.y = 0
