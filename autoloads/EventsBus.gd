extends Node

signal phase_changed(is_night : bool)
signal resource_collected(resource, amount : int)
signal xp_gained(amount : int)
signal level_up_triggered(new_level : int)
signal upgrade_selected(upgrade: Upgrade)
signal boss_defeated()
signal reset_to_day(player_died : bool)
signal game_fail()