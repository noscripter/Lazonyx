extends Node

const LEVEL_1 = "res://stages/lvl_1.tscn"

func _ready():

	pass

func load_level(LEVEL):
	var file_to_check = File.new()
	var file_exists = file_to_check.file_exists(LEVEL)
	if file_exists:
		get_tree().change_scene(LEVEL)
	else:
		print(LEVEL + " is not a valid file")