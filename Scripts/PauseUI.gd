extends Control


onready var ResumeBtn = $"Resume Btn"


func _ready():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	


func _physics_process(delta):
	pauseGame()


func pauseGame():
	if Input.is_action_pressed("ui_cancel"):
		MusicController.pause_track()
		visible = true
		Engine.time_scale = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


#Resume The Game
func _on_Resume_Btn_pressed():
	MusicController.unpause_track()
	visible = false
	Engine.time_scale = 1
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


#Quit Game
func _on_Exit_Btn_pressed():
	get_tree().change_scene("res://Scenes/Main Menu.tscn")
	Engine.time_scale = 1
