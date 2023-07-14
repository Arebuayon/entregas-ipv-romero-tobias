extends Control


func _ready() -> void:
	GameState.connect("level_won", self, "_on_level_won")
	hide()


func _on_level_won() -> void:
	show()
