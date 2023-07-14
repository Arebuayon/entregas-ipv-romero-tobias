extends Node

export (Array, PackedScene) var levels: Array
export (String) var main_menu_path: String

export (NodePath) var transition_anim_path: NodePath
onready var transition_anim: AnimationPlayer = get_node(transition_anim_path)

onready var current_level_container: Node = $CurrentLevelContainer

var level: int = 0
var current_level: GameLevel


func _ready() -> void:
	call_deferred("_setup_level", level)
	GameState.connect("level_won", self, "_on_pause")


func _setup_level(id: int) -> void:
	if id >= 0 && id < levels.size():
		if current_level:
			current_level_container.remove_child(current_level)
			current_level.queue_free()
		
		current_level = levels[id].instance()
		current_level_container.add_child(current_level)
	transition_anim.play("enter")
	get_tree().set_deferred("paused", false)


func _return_called() -> void:
	transition_anim.play("exit")
	current_level.notify_exit()
	yield(transition_anim, "animation_finished")
	get_tree().paused = false
	get_tree().change_scene(main_menu_path)


func _restart_called() -> void:
	transition_anim.play("exit")
	current_level.notify_exit()
	yield(transition_anim, "animation_finished")
	_setup_level(level)


func _next_called() -> void:
	transition_anim.play("exit")
	current_level.notify_exit()
	yield(transition_anim, "animation_finished")
	level = min(level + 1, levels.size() - 1)
	_setup_level(level)


func _on_pause() -> void:
	current_level.notify_pause()
	get_tree().paused = true


func _on_resume() -> void:
	current_level.notify_resume()
	get_tree().paused = false
	
