extends Node

export (Array, PackedScene) var levels: Array

onready var current_level_container: Node = $CurrentLevelContainer
onready var pause_layer = $PauseLayer

## This won't run by itself. Use all variables and functions necessary to run this correctly.
func _ready():
	_setup_level(0)

func _setup_level(id: int) -> void:
	if id >= 0 && id < levels.size():
		if current_level_container.get_child_count() > 0:
			for child in current_level_container.get_children():
				current_level_container.remove_child(child)
				child.queue_free()
		var level_instance: GameLevel = levels[id].instance()
		current_level_container.add_child(level_instance)

func _input(event):
	if (event.is_action_pressed("ui_cancel")):
		get_tree().paused = true
		$PauseLayer.visible = true

