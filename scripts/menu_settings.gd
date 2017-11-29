extends Node

const MUSIC_BACKGROUND = "Lazonyx_idea_v1"
const SOUND_EXAMPLE    = "Hit_03"
  
onready var canvas              = get_node("canvas")
onready var music_player        = get_node("music_player")
onready var sample_player       = get_node("sample_player")
onready var slider_sound_volume = canvas.get_node("slider_sound_volume")
onready var slider_music_volume = canvas.get_node("slider_music_volume")
onready var btn_return          = canvas.get_node("btn_return")

var music_voice_id = null

const OFFSET_HIDE = Vector2(1000,1000)
const OFFSET_SHOW = Vector2(0,0)

signal btn_return_pressed

func _ready():
	slider_sound_volume.set_value(file_manager.load_sound_volume())
	slider_sound_volume.connect("value_changed",  self, "_slider_sound_volume_value_changed")
	slider_music_volume.set_value(file_manager.load_music_volume())
	slider_music_volume.connect("value_changed",  self, "_slider_music_volume_value_changed")
	
	btn_return.connect("pressed", self, "_btn_return_pressed")
	show()
	pass

func hide():
	music_player.stop_all()
	canvas.set_offset(OFFSET_HIDE)
	
func show():
	music_voice_id = music_player.play(MUSIC_BACKGROUND)
	music_player.set_volume(music_voice_id, slider_music_volume.get_val())
	print("show settings menu")
	canvas.set_offset(OFFSET_SHOW)
	
func _slider_music_volume_value_changed(value):
	music_player.set_volume(music_voice_id, value)
	
func _slider_sound_volume_value_changed(value):
	print("sound value changed: " + str(value))
	var voice_id = sample_player.play(SOUND_EXAMPLE)
	sample_player.set_volume(voice_id, slider_sound_volume.get_value())
	
func _btn_return_pressed():
	file_manager.save_sound_volume(slider_sound_volume.get_val())
	file_manager.save_music_volume(slider_music_volume.get_val())
	emit_signal("btn_return_pressed")