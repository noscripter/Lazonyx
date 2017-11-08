extends Node

onready var orb = preload("res://prefabs/orb.tscn")


func _ready():
	
	pass

func enemy_died(death_position, death_velocity):
	var new_orb = orb.instance()
	new_orb.set_pos(death_position)
	new_orb.set_linear_velocity(death_velocity)
	game_manager.add_to_current_scene(new_orb)
	
func add_to_current_scene(object):
	get_tree().get_root().add_child(object)