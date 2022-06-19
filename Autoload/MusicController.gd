extends Node


onready var MusicStream = $Music

var soundtrack = load("res://Assets/Sound/Hell Rush Sound 2.mp3")


func unpause_track():
	MusicStream.stream = soundtrack
	MusicStream.playing = true


func pause_track():
	MusicStream.stream = soundtrack
	MusicStream.playing = false


#Play Audio Track
func play_track():
	MusicStream.stream = soundtrack
	MusicStream.play()
	MusicStream.volume_db = -10
