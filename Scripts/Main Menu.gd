extends Control


func _ready():
	MusicController.play_track()


#Play Btn Pressed
func _on_Play_Btn_pressed():
	get_tree().change_scene("res://Scenes/Level Select Menu.tscn")


#Exit Btn Pressed
func _on_Exit_Btn_pressed():
	get_tree().quit()
