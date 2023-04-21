extends Sprite

onready var fire_position:Position2D = $ShootPosition

export(PackedScene) var ball_scene

var ball_container:Node

func fire():
	var ball_instance:Ball = ball_scene.instance()
	ball_container.add_child(ball_instance)
	ball_instance.set_starting_values(fire_position.global_position , (fire_position.global_position - global_position).normalized() , rotation)
	ball_instance.connect("delete_requested",self,"_on_ball_delete_requested")	
	
func _on_ball_delete_requested(ball):
	ball_container.remove_child((ball))
	ball.queue_free()
	print("borre player")
