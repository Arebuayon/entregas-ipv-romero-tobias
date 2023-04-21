extends Node

func _ready():
	$Player.set_ball_container(self)
	$Turret.set_values(self, $TurretSpawner/CollisionShape2D)
	$Turret2.set_values(self , $TurretSpawner/CollisionShape2D)
	$Turret3.set_values(self , $TurretSpawner/CollisionShape2D)
