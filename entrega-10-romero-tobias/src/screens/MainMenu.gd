extends Node

export (PackedScene) var level_manager_scene: PackedScene
onready var trans_animation: AnimationPlayer = $TransitionAnimation


func _ready() -> void:
	trans_animation.play("enter")


func _on_StartButton_pressed() -> void:
	trans_animation.play("exit")
	yield(trans_animation, "animation_finished")
	get_tree().change_scene_to(level_manager_scene)


func _on_ExitButton_pressed() -> void:
	trans_animation.play("exit")
	yield(trans_animation, "animation_finished")
	get_tree().quit()

