extends Node2D

func _ready():
	pass

func spawn_enemy():
	var new_enemy = file_manager.ENEMY_PREFAB.instance()
	new_enemy.set_pos(get_pos())
	get_parent().add_child(new_enemy)