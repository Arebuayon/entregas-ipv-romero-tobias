extends Sprite

export var speed = 20.0
onready var cannon:Sprite = $Cannon
var ball_container:Node
var velocity = Vector2.ZERO
export var max_speed = 600.0
export var friction = 0.1

func set_ball_container(container:Node):
	cannon.ball_container = container
	ball_container = container
	
func _physics_process(delta):

	var direction:int = 0
	if Input.is_action_pressed("move_left"):
		direction = -1
	elif Input.is_action_pressed("move_right"):
		direction = 1

	var mouse_position:Vector2 = get_global_mouse_position()
	
	cannon.look_at(mouse_position)
	
	if Input.is_action_just_pressed("shoot"):
		cannon.fire()
	
	velocity.x += direction * speed 
	
	if direction != 0:
		velocity.x = clamp(velocity.x , -max_speed, max_speed)
	else:
		velocity.x = lerp(velocity.x, 0, friction) if abs(velocity.x) > 1 else 0
	position += velocity * delta
