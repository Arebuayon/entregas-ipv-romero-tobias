extends Sprite

var player : Sprite
export (PackedScene) var turret_ball_scene:PackedScene

onready var fire_position:Position2D = $FirePosition

var ball_container:Node
var screen_size

var rng = RandomNumberGenerator.new()
	
func set_values(player , ball_container):
	self.player = player
	self.ball_container = ball_container
	$Timer.start()
	screen_size = get_viewport_rect()
	rng.randomize()
	var obj_pos_x = rng.randf_range(screen_size.position.x , screen_size.size.x)
	var obj_pos_y = rng.randf_range(screen_size.position.y , (player.position.y - player.texture.get_height()))
	position = Vector2(obj_pos_x , obj_pos_y)


func _on_Timer_timeout():
	fire()


func fire():
	var turret_ball = turret_ball_scene.instance()
	ball_container.add_child(turret_ball)
	turret_ball.set_starting_values(fire_position.global_position , (player.global_position - fire_position.global_position).normalized())
	turret_ball.connect("delete_requested" , self , "_on_ball_delete_requested")
	
func _on_ball_delete_requested(ball):
	ball_container.remove_child(ball)
	ball.queue_free()
	print("borre turret")
