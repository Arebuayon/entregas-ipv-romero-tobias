extends Node

func _ready():
	$Player.set_ball_container(self)
	$TurretSpawner.spawn_turrets()


func _on_Coin_body_entered(body):
	$Coin.queue_free()
	get_tree().set_pause(true)
