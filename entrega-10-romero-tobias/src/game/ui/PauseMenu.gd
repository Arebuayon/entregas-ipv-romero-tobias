extends Control

export (NodePath) var open_sound_path: NodePath
onready var open_sound: AudioStreamPlayer = get_node(open_sound_path)


func _ready() -> void:
	hide()


func show() -> void:
	.show()
	open_sound.play()
