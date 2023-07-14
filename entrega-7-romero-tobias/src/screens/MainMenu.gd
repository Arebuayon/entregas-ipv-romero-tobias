extends Node

func _on_Start_pressed():
	var new_scene = load("res://src/game/levels/LevelManager.tscn")
	get_tree().change_scene_to(new_scene)

func _on_Exit_pressed():
	get_tree().quit()
