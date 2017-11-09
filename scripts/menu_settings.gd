extends Node

onready var canvas = get_node("canvas")
const OFFSET_HIDE = Vector2(-1000,-1000)
const OFFSET_SHOW = Vector2(0,0)

func _ready():
	show()
	pass

func hide():
	canvas.set_offset(OFFSET_HIDE)
	
func show():
	canvas.set_offset(OFFSET_SHOW)