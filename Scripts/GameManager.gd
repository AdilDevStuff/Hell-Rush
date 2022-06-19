extends Spatial


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


#Process Function
func _process(delta):
	#R To Restart Game
	RtoRestart()
	


#Restart Game with R Key
func RtoRestart():
	if Input.is_action_pressed("Restart"):
		get_tree().reload_current_scene()

