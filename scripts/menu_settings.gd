extends Node

const MUSIC_BACKGROUND = "Lazonyx_idea_v1"
  
onready var canvas              = get_node("canvas")
onready var music_player        = get_node("music_player")
onready var slider_music_volume = canvas.get_node("slider_music_volume")

var music_voice_id = null

const OFFSET_HIDE = Vector2(1000,1000)
const OFFSET_SHOW = Vector2(0,0)

func _ready():
	
	slider_music_volume.connect("value_changed",  self, "_slider_music_volume_value_changed")
	show()
	pass

func hide():
	music_player.stop_all()
	canvas.set_offset(OFFSET_HIDE)
	
func show():
	music_voice_id = music_player.play(MUSIC_BACKGROUND)
	print("show settings menu")
	canvas.set_offset(OFFSET_SHOW)
	
	
func _slider_music_volume_value_changed(value):
	print("value changed: " + str(value))
	music_player.set_volume(music_voice_id, value)