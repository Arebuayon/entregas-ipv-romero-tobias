extends Node
class_name GameLevel

export (NodePath) var bgm_anim_path: NodePath
onready var bgm_anim: AnimationPlayer = get_node_or_null(bgm_anim_path)


## You shouldn't load this scene directly, the LevelManager should do that for you.

## This script should be the same for all levels. If you need to extend it's functionality
## check if you either need it for all levels or just for that single level.

func _ready() -> void:
	randomize()
	if bgm_anim:
		bgm_anim.play("enter")


func notify_pause() -> void:
	if bgm_anim:
		bgm_anim.play("pause")


func notify_resume() -> void:
	if bgm_anim:
		bgm_anim.play("resume")


func notify_exit() -> void:
	if bgm_anim:
		bgm_anim.play("exit")
