extends KinematicBody2D

onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer
onready var raycast = $RayCast2D
export (int) var gravity = 10

export (PackedScene) var projectile_scene

onready var anim:AnimatedSprite = $turret
var target
var projectile_container

var motion = Vector2.ZERO

func _ready():
	fire_timer.connect("timeout", self, "fire")
	#set_physics_process(false)

func initialize(container, turret_pos, projectile_container):
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container
	

func fire():
	if target != null:
		var proj_instance = projectile_scene.instance()
		if projectile_container == null:
			projectile_container = get_parent()
		proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position))
		fire_timer.start()

func _physics_process(delta):
	if not is_on_floor():
		_play_anim("fall")
	else:
		_play_anim("idle")
	if target != null:
		raycast.set_cast_to(raycast.to_local(target.global_position))
		if raycast.is_colliding() && raycast.get_collider() == target:
			if fire_timer.is_stopped():
				fire_timer.start()
		elif !fire_timer.is_stopped():
			fire_timer.stop()
	motion.y += gravity
	motion = move_and_slide(motion, Vector2.UP)


func notify_hit():
	print("I'm turret and imma die")
	call_deferred("_remove")

func _remove():
	set_physics_process(false)
	$DetectionArea.monitoring = false
	_play_anim("dead")


func _play_anim(anim_name):
	anim.play(anim_name)

func _on_DetectionArea_body_entered(body):
	if target == null:
		target=body
		#set_physics_process(true)

func _on_DetectionArea_body_exited(body):
	if body == target:
		target = null
		#set_physics_process(false)


func _on_turret_animation_finished():
	if anim.animation == "dead":
			get_parent().remove_child(self)
			queue_free()
