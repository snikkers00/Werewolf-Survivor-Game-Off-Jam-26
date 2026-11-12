extends Node


var days_lasted : int = 0
var resources_gathered : int = 0
var total_exp_gained : float = 0.0
var enemies_killed : int = 0
var lives_remaining : int = 3

func reset_stats():
	days_lasted = 0
	resources_gathered = 0
	total_exp_gained  = 0.0
	enemies_killed = 0
	lives_remaining = 3
