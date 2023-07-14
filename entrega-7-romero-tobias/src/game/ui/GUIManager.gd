extends Control

var hearts: int = 3
onready var level_manager= get_parent().get_parent()
onready var level_container = level_manager.get_node("CurrentLevelContainer")
var player 	
func _ready():
	call_deferred("set_player")

func set_player():
	player = level_container.get_child(0).get_node("Environment/Entities/Player")
	player.connect("hit",self,"_on_player_hit")
	
func _on_player_hit():
	if (hearts == 0 ): return
	var heart: TextureRect = get_node("Heart" + str(hearts))
	var texture = load("res://assets/textures/ui/gui/hud_heartEmpty.png")
	heart.set_texture(texture)
	heart.texture = texture
	hearts -= 1
