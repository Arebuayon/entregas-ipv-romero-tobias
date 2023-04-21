extends StaticBody2D

export (PackedScene) var turret_ball_scene:PackedScene
var target : Node2D
onready var fire_position:Position2D = $FirePosition
var ball_container:Node
var screen_size
var space_state
var rng = RandomNumberGenerator.new()
	
func _ready():
	space_state = get_world_2d().direct_space_state
	
func set_values(ball_container , spawner : CollisionShape2D):
	var visible_rect = spawner.global_position
	self.ball_container = ball_container
	screen_size = get_viewport_rect()
	rng.randomize()
	var obj_pos_x = rng.randf_range(visible_rect.x , visible_rect.x)
	var obj_pos_y = rng.randf_range(visible_rect.y , visible_rect.y)
	position = Vector2(obj_pos_x , obj_pos_y)


func _on_Timer_timeout():
	fire()


func fire():
	var raycast :Dictionary = space_state.intersect_ray(fire_position.global_position , target.global_position)
	if raycast.collider is Player:
		var turret_ball = turret_ball_scene.instance()
		ball_container.add_child(turret_ball)
		turret_ball.set_starting_values(fire_position.global_position , (target.global_position - fire_position.global_position).normalized() , rotation)
		turret_ball.connect("delete_requested" , self , "_on_ball_delete_requested")
	
func _on_ball_delete_requested(ball):
	ball_container.remove_child(ball)
	ball.queue_free()

func _on_DetectionArea_body_entered(body):
	if target == null:
		target = body
		$Timer.start()
	


func _on_DetectionArea_body_exited(body):
	if target == body:
		target = null
		$Timer.stop()

