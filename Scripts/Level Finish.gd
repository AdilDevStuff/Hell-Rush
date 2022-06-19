extends CSGBox




func _on_Area_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Scenes/Level 1.tscn")


func _on_LvlFinish1_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Scenes/Level 2.tscn")


func _on_LevelFinish2_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Scenes/Level 3.tscn")


func _on_LevelFinish3_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Scenes/Game Complete UI.tscn")
