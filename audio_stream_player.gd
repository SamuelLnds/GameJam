extends AudioStreamPlayer

var paul_dead = preload("res://Assets/SFX/mort_paul.mp3")
var paul_on_hit = preload("res://Assets/SFX/seprenduncoup_paul.mp3")
var paul_win = preload("res://Assets/SFX/victoire_paul.mp3")

var hartal_dead = preload("res://Assets/SFX/mort_hartal.mp3")
var hartal_on_hit = preload("res://Assets/SFX/seprenduncoup_hartal.mp3")
var hartal_win = preload("res://Assets/SFX/victoire_hartal.mp3")

var audio_node = null

func _ready():
	audio_node = $Audio_Stream_Player
	audio_node.connect("finished", self)
	audio_node.stop()
	
	
