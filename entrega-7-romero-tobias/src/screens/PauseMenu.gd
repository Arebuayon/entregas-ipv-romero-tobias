extends CanvasLayer



func _on_Continue_pressed():
	visible = false
	get_tree().paused = false

func _on_Exit_pressed():
	visible = false
	get_tree().paused = false
	var new_main = load("res://src/screens/MainMenu.tscn")
	get_tree().change_scene_to(new_main)
