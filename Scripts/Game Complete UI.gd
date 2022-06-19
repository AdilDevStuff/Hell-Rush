extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



#Press to restart game from level 0
func _on_Play_Again_Btn_pressed():
	get_tree().change_scene("res://Scenes/Level0.tscn")


#Press to exit the game
func _on_Exit_Btn_pressed():
	get_tree().quit()
