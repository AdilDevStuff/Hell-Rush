extends Spatial



func _on_LaserArea_V_body_entered(body):
	if body.name == "Player":
		get_tree().reload_current_scene()
