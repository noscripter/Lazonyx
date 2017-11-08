extends Node

onready var canvas       = get_node("canvas")
onready var anim         = canvas.get_node("anim")
onready var btn_play     = canvas.get_node("btn_play")
onready var btn_settings = canvas.get_node("btn_settings")

func _ready():
	btn_play.connect    ("pressed", self, "_btn_play_pressed")
	btn_settings.connect("pressed", self, "_btn_settings_pressed")
	pass

func _btn_play_pressed():
	stage_manager.load_level(stage_manager.LEVEL_1)
	
func _btn_settings_pressed():
	print("btn_settings pressed")