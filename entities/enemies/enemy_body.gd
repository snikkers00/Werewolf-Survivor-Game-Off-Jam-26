extends CharacterBody3D

@onready var health_bar = %HealthBar

@export var SPEED: float = 1
@onready var enemysprite: AnimatedSprite3D = %EnemySprite
@export var enemy_damage: int
@export var enemy_xp_value: int
@onready var health_comp = $Health

@export var is_boss: bool = false
@onready var enemy_hurt_player : AudioStreamPlayer3D = %EnemyHurtSFX

var player: Node3D
var knockback_velocity: Vector3 = Vector3.ZERO
var base_modulate: Color
var damage_tween: Tween

func _ready():
	health_comp.death.connect(die)
	player = get_tree().get_first_node_in_group("Player")
	#health_bar.max_value = health_comp.health
	#health_bar.value = health_comp.health
	base_modulate = enemysprite.modulate
	enemysprite.play("move")
	_setup_sprite_shader(enemysprite)


func _setup_sprite_shader(sprite: AnimatedSprite3D) -> void:
	if sprite.material_override is ShaderMaterial:
		sprite.material_override = sprite.material_override.duplicate()
		sprite.frame_changed.connect(_sync_sprite_shader.bind(sprite))
		sprite.animation_changed.connect(_sync_sprite_shader.bind(sprite))
		_sync_sprite_shader(sprite)


func _sync_sprite_shader(sprite: AnimatedSprite3D) -> void:
	if sprite.material_override is ShaderMaterial and sprite.sprite_frames:
		var tex := sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
		sprite.material_override.set_shader_parameter("albedo_tex", tex.atlas if tex is AtlasTexture else tex)


func _physics_process(_delta):
	if not is_on_floor():
		velocity += get_gravity() * _delta
	var player_postion: Vector3 = player.global_position
	if player_postion != null:
		var dir_to_player = global_position.direction_to(player_postion).normalized()
		velocity.x = dir_to_player.x * SPEED + knockback_velocity.x
		velocity.z = dir_to_player.z * SPEED + knockback_velocity.z
		move_and_slide()
		knockback_velocity = knockback_velocity.move_toward(Vector3.ZERO, 20 * _delta)


	elif player_postion == null:
		print("player position invalid")
		
	if velocity.x > 0:
		enemysprite.flip_h = false
	
	elif velocity.x < 0:
		enemysprite.flip_h = true


func die():
	EventsBus.xp_gained.emit(enemy_xp_value)
	RunStats.enemies_killed += 1
	if is_boss == true:
		EventsBus.boss_defeated.emit(true)
	queue_free()


func _on_enemy_hurtbox_area_entered(area):
	health_comp.damage(area.damage)
	if not is_queued_for_deletion():
		flash_damage()
	#health_bar.value -= area.damage
	var player_postion: Vector3 = player.global_position
	knockback_velocity = (global_position.direction_to(player_postion) * -1) * 8
	knockback_velocity.y = 0

func flash_damage():
	if damage_tween:
		damage_tween.kill()
	var mat := enemysprite.material_override as ShaderMaterial
	if mat:
		mat.set_shader_parameter("unshaded", 1.0)
		mat.set_shader_parameter("modulate", Color(2.0, 2.0, 2.0))
		damage_tween = create_tween()
		damage_tween.tween_property(mat, "shader_parameter/modulate", Color(2.0, 0.3, 0.3), 0.06)
		damage_tween.tween_property(mat, "shader_parameter/modulate", base_modulate, 0.16)
		damage_tween.tween_property(mat, "shader_parameter/unshaded", 0.0, 0.0)
