extends Node

func _ready():
	for child in get_children():
		child.hide()
	pass

func get_random_location():
	var points = get_children()
	var count  = points.size()
	var index = floor(rand_range(0,count))
	return points[index].get_global_pos()