extends Area2D
class_name Ball
signal delete_requested(ball)

var direction:Vector2
	
export(float) var speed

var screen_size

func _ready():
	set_physics_process(false)
	screen_size = get_viewport_rect()

func set_starting_values(starting_position:Vector2 , direction:Vector2 , rotationC:float):
	global_position = starting_position
	self.direction = direction
	self.rotation = rotationC
	$Timer.start()
	set_physics_process(true)


func _physics_process(delta):
	position += direction*speed*delta
	var obj_pos = position

	#if obj_pos.x < screen_size.position.x or obj_pos.x > screen_size.size.x or obj_pos.y < screen_size.position.y or obj_pos.y > screen_size.size.y:
	#	emit_signal("delete_requested" , self)


func _on_Ball_body_entered(body):
	body.death()


func _on_Timer_timeout():
	emit_signal("delete_requested" , self)
