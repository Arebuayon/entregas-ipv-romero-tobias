extends KinematicBody2D

onready var cannon = $Cannon

const FLOOR_NORMAL := Vector2.UP  # Igual a Vector2(0, -1)
const SNAP_DIRECTION := Vector2.UP
const SNAP_LENGHT := 32.0
const SLOPE_THRESHOLD := deg2rad(46)

export (float) var ACCELERATION:float = 60.0
export (float) var H_SPEED_LIMIT:float = 600.0
export (int) var jump_speed = 500
export (float) var FRICTION_WEIGHT:float = 0.1
export (int) var gravity = 10

onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var body:Sprite = $Body
var projectile_container

var velocity:Vector2 = Vector2.ZERO
var snap_vector:Vector2 = SNAP_DIRECTION * SNAP_LENGHT

var is_jumping:bool = false

func _ready() -> void:
	initialize()


func initialize(projectile_container: Node = get_parent()) -> void:
	self.projectile_container = projectile_container
	cannon.projectile_container = projectile_container


func _process_input() -> void:
	# Cannon fire
	if Input.is_action_just_pressed("fire_cannon"):
		if projectile_container == null:
			projectile_container = get_parent()
			cannon.projectile_container = projectile_container
		cannon.fire()

	# Jump Action
	var jump = Input.is_action_just_pressed('jump')
	if jump and is_on_floor():
		is_jumping = true
		if body.is_flipped_h():
			_play_animation("jump_f")
		else:
			_play_animation("jump")
		velocity.y -= jump_speed

	#horizontal speed
	var h_movement_direction:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if h_movement_direction != 0:
		velocity.x = clamp(velocity.x + (h_movement_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
		if h_movement_direction > 0 :
			body.flip_h = false		
		if h_movement_direction < 0:
			body.flip_h = true
		if not is_jumping:
			if body.is_flipped_h():
				_play_animation("walk_f")
			else:
				_play_animation("walk")
	elif not is_jumping:
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
		_play_animation("idle")

	var mouse_position:Vector2 = get_global_mouse_position()
	cannon.look_at(mouse_position)


func _physics_process(delta) -> void:
	_process_input()
	velocity.y += gravity
	velocity = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, true, 4, SLOPE_THRESHOLD)


func notify_hit() -> void:
	print("I'm player and imma die")
	call_deferred("_remove")


func _remove() -> void:
	set_physics_process(false)
	#hide()
	print(body.is_flipped_h())
	if body.is_flipped_h():
		_play_animation("dead 2")
	else:
		_play_animation("dead")
	collision_layer = 0

func _play_animation(anim:String):
	if animation_player.has_animation(anim):
		animation_player.play(anim)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "jump":
		is_jumping = false
