extends KinematicBody2D
class_name Player
export var speed = 10.0
onready var cannon:Sprite = $Cannon
var ball_container:Node
var velocity = Vector2.ZERO
export var max_speed = 400
export var friction = 0.1
export var jump_speed = -20.0
export var gravity = 2.0
var esta_disparando = false
var esta_saltando = false
var esta_muerto = false


func set_ball_container(container:Node):
	cannon.ball_container = container
	ball_container = container
	
func _physics_process(delta):

	var mouse_position:Vector2 = get_global_mouse_position()
	
	cannon.look_at(mouse_position)
	
	#DISPARO
	if Input.is_action_just_pressed("shoot"):
		if not esta_disparando && not esta_saltando && not esta_muerto:
			$AnimatedSprite.set_speed_scale(5.0)
			$AnimatedSprite.play("shoot")
			esta_disparando = true
	
	#SALTO
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() && not esta_disparando && not esta_muerto:
			esta_saltando = true
			$AnimatedSprite.set_speed_scale(2.0)
			$AnimatedSprite.play("jump")	
			velocity.y = jump_speed
	if not is_on_floor():
		velocity.y += gravity
	
	#MOVIMIENTO
	if not esta_disparando && not esta_saltando && not esta_muerto:
		var direction:int = 0
		if Input.is_action_pressed("move_left"):
			direction = -1
		elif Input.is_action_pressed("move_right"):
			direction = 1
		velocity.x += direction * speed 
		if direction != 0:
			velocity.x = clamp(velocity.x , -max_speed, max_speed)
			if abs(velocity.x) > 300:
				$AnimatedSprite.play("run")
			if direction > 0 && abs(velocity.x) < 300:
				$AnimatedSprite.set_scale(Vector2(1 , get_scale().y))
				$AnimatedSprite.play("walk")
			elif direction < 0 && abs(velocity.x) < 300:
				$AnimatedSprite.set_scale(Vector2(-1 , get_scale().y))
				$AnimatedSprite.play("walk")
		else:
			velocity.x = lerp(velocity.x, 0, friction) if abs(velocity.x) > 1 else 0
			$AnimatedSprite.play("idle")
		move_and_slide_with_snap(velocity,Vector2(0,-1),Vector2.UP)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "shoot":
		cannon.fire()
		$AnimatedSprite.set_speed_scale(1.0)
		$AnimatedSprite.play("idle")
		esta_disparando = false
	if $AnimatedSprite.animation == "jump":
		$AnimatedSprite.set_speed_scale(1.0)
		$AnimatedSprite.play("idle")
		esta_saltando = false

func death():
	esta_muerto = true
	$Collision.disabled = true
	$AnimatedSprite.stop()
	$AnimatedSprite.play("death")


