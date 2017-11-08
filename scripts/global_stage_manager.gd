extends Node

var LEVEL_1


func _ready():
	LEVEL_1 = file_manager.LEVEL_1_FILE
	pass

func load_level(LEVEL):
	var file_to_check = File.new()
	var file_exists = file_to_check.file_exists(LEVEL)
	if file_exists:
		get_tree().change_scene(LEVEL)
	else:
		print(LEVEL + " is not a valid file")
		
func add_to_current_scene(object):
	get_tree().get_root().add_child(object)