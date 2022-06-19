extends Control



#Start Level 0
func _on_Level_0_pressed():
	get_tree().change_scene("res://Scenes/Level0.tscn")


#Start Level 1
func _on_Level_1_pressed():
	get_tree().change_scene("res://Scenes/Level 1.tscn")


#Start Level 2
func _on_Level_2_pressed():
	get_tree().change_scene("res://Scenes/Level 2.tscn")


#Start Level 3
func _on_Level_3_pressed():
	get_tree().change_scene("res://Scenes/Level 3.tscn")


# Go Back To Menu 
func _on_Menu_pressed():
	get_tree().change_scene("res://Scenes/Main Menu.tscn")
