extends Node

export (PackedScene) var level_manager_scene: PackedScene
onready var fx = $Fx
signal _on_audio_finished_exit()
signal _on_audio_finished()

func _on_StartButton_pressed() -> void:
	fx.play()
	fx.connect("finished", self, "_on_audio_finished")
	


func _on_ExitButton_pressed() -> void:
	fx.connect("finished", self, "_on_audio_finished_exit")
	fx.play()

func _on_audio_finished() -> void:
	get_tree().change_scene_to(level_manager_scene)

func _on_audio_finished_exit() -> void:
	get_tree().quit()
