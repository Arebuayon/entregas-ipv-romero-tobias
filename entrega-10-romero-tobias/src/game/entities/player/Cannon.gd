extends Sprite

onready var cannon_tip: Node2D = $CannonTip
onready var shoot_sfx: Node = $ShootSfx

export (PackedScene) var projectile_scene:PackedScene

var projectile_container
var proj_instance 


func fire():
	proj_instance = projectile_scene.instance()
	proj_instance.initialize(projectile_container, cannon_tip.global_position, global_position.direction_to(cannon_tip.global_position))
	shoot_sfx.play()


func add_collision_exception_to_projectile(object):
	proj_instance.add_collision_exception_to_projectile(object)
