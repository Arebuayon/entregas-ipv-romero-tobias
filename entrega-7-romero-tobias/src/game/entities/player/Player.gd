extends KinematicBody2D

signal hit();

const FLOOR_NORMAL := Vector2.UP  # Igual a Vector2(0, -1)
const SNAP_DIRECTION := Vector2.UP
const SNAP_LENGHT := 32.0
const SLOPE_THRESHOLD := deg2rad(46)

onready var cannon_container: Node2D = $Body/Slime/CannonContainer
onready var cannon: Sprite = $Body/Slime/CannonContainer/Cannon
onready var body: Sprite = $Body
onready var floor_raycasts:Array = $FloorRaycasts.get_children()
onready var body_animations: AnimationPlayer = $BodyAnimations

export (float) var ACCELERATION:float = 60.0
export (float) var H_SPEED_LIMIT:float = 600.0
export (int) var jump_speed = 500
export (float) var FRICTION_WEIGHT:float = 0.1
export (int) var gravity = 10
export (int) var life = 3

var projectile_container

var velocity:Vector2 = Vector2.ZERO
var snap_vector:Vector2 = SNAP_DIRECTION * SNAP_LENGHT

var dead: bool = false


func _ready() -> void:
	initialize()


func initialize(projectile_container: Node = get_parent()) -> void:
	self.projectile_container = projectile_container
	cannon.projectile_container = projectile_container
	_change_animation("idle")

func _process_input() -> void:
	if dead:
		return

	# Horizontal movement
	var h_movement_direction:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if h_movement_direction != 0:
		velocity.x = clamp(velocity.x + (h_movement_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0

	if h_movement_direction < 0:
		body.flip_h = true
		body.offset.x = -50
	elif h_movement_direction > 0:
		body.flip_h = false
		body.offset.x = 50

	# Jump Action
	var jump: bool = Input.is_action_just_pressed('jump')
	var on_floor: bool = is_on_floor()
	if jump && on_floor:
		velocity.y -= jump_speed
	
	if on_floor:
		if h_movement_direction != 0:
			_change_animation("walk")
		else:
			_change_animation("idle")
	else:
		_change_animation("jump")

	#cannon handling
	var mouse_position_normalized:Vector2 = (get_global_mouse_position() - cannon.global_position).normalized()
	
	if mouse_position_normalized.x < 0:
		cannon_container.scale.x = -1
		mouse_position_normalized.x *= -1
	else:
		cannon_container.scale.x = 1
	
	cannon.rotation = mouse_position_normalized.angle()

	# Cannon fire
	if Input.is_action_just_pressed("fire_cannon"):
		if projectile_container == null:
			projectile_container = get_parent()
			cannon.projectile_container = projectile_container
		cannon.fire()


func _physics_process(delta) -> void:
	_process_input()
	velocity.y += gravity
	velocity = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, true, 4, SLOPE_THRESHOLD)


## Gotta add hp here. To communicate with the UI to handle the data, you can either
## propagate some "hit"/"hp_changed" signal via Level, or you can use Autoload/Singletons.
func notify_hit() -> void:
	life -= 1;
	emit_signal("hit")
	if (life == 0):
		dead = true
		_change_animation("dead")

func _remove() -> void:
	set_physics_process(false)
	hide()
	collision_layer = 0


func is_on_floor()->bool:
	var is_colliding:bool = .is_on_floor()
	for raycast in floor_raycasts:
		raycast.force_raycast_update()
		is_colliding = is_colliding || raycast.is_colliding()
	return is_colliding


func _change_animation(anim_name: String) -> void:
	if body_animations.has_animation(anim_name):
		body_animations.play(anim_name)


func _on_BodyAnimations_animation_finished(anim_name: String) -> void:
	if anim_name == "dead":
		call_deferred("_remove")
