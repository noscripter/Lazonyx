extends Node

onready var canvas        = get_node("canvas")
onready var btn_resume    = canvas.get_node("container_btns/btn_resume")
onready var btn_settings  = canvas.get_node("container_btns/btn_settings")
onready var btn_main_menu = canvas.get_node("container_btns/btn_main_menu")
onready var btn_controls  = canvas.get_node("container_btns/btn_controls")


const OFFSET_HIDE = Vector2(1000,1000)
const OFFSET_SHOW = Vector2(0,0)

func _ready():
	hide()
	print(btn_resume.get_rect())
	pass

func hide():
	canvas.set_offset(OFFSET_HIDE)
	
func show():
	canvas.set_offset(OFFSET_SHOW)