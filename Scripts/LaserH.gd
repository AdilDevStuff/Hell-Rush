extends Spatial


func _on_LaserArea_H_body_entered(body):
	if body.name == "Player":
		get_tree().reload_current_scene()
