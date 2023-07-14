extends Control

onready var defeat_anim: AnimationPlayer = $DefeatAnim


func _ready() -> void:
	GameState.connect("updated_current_player", self, "_on_updated_current_player")
	hide()


func _on_updated_current_player(current_player: Player) -> void:
	current_player.connect("dead", self, "_on_player_dead")


func _on_player_dead() -> void:
	show()
	defeat_anim.play("show")

