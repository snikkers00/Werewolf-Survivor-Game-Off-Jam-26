extends Resource
class_name Upgrade


enum StatModified {
	HEALTH,
	DAMAGE,
	ATTACK_SPEED,
	MOVEMENT_SPEED,
	RESOURCE_GAIN,
	XP_GAIN
}

@export var name : String
@export var description : String
@export var stat_modified : StatModified
@export var stat_modifier : float
@export var icon : Texture2D

