extends Control


func _ready() -> void:
	GameState.connect("updated_current_player", self, "_on_updated_current_player")
	hide()


func _on_updated_current_player(current_player: Player) -> void:
	current_player.connect("dead", self, "_on_player_dead")


func _on_player_dead() -> void:
	yield(get_tree().create_timer(4.0), "timeout")
	show()


func show() -> void:
	.show()
	get_tree().paused = true


func hide() -> void:
	.hide()
	get_tree().paused = false
