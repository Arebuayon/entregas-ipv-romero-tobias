extends KinematicBody2D

onready var fire_position: Node2D = $FirePosition
onready var fire_timer: Timer = $FireTimer
onready var raycast: RayCast2D = $RayCast2D
onready var body: AnimatedSprite = $Body
onready var idle_timer : Timer = $IdleTimer

export (PackedScene) var projectile_scene
export (Vector2) var gravity: Vector2
export (float) var speed : float = 10
export (float) var max_speed : float = 50

export(Vector2) var wandering_range:Vector2

var velocity: Vector2 = Vector2.ZERO

var target
var projectile_container
var pathfinding
var path:Array  = []

var dead: bool = false


func _ready() -> void:
	fire_timer.connect("timeout", self, "fire")
	idle_timer.start()


func initialize(container, turret_pos, projectile_container: Node = get_parent()) -> void:
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container
	_change_anim("idle")


func fire():
	if target != null:
		var proj_instance = projectile_scene.instance()
		if projectile_container == null:
			projectile_container = get_parent()
		proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position))
		_change_anim("shoot")
		fire_timer.start()


func _change_anim(anim: String) -> void:
	if body.frames.has_animation(anim):
		body.play(anim)


func _physics_process(delta: float) -> void:
		
	if target != null && !dead:
		body.flip_h = target.global_position.x - global_position.x < 0
	
		raycast.set_cast_to(raycast.to_local(target.global_position))
		if raycast.is_colliding() && raycast.get_collider() == target:
			if fire_timer.is_stopped():
				fire_timer.start()
		elif !fire_timer.is_stopped():
			fire_timer.stop()
	if !path.empty() && !dead:
		var next_point:Vector2 = to_local(path.front())
		while !path.empty() && position.distance_to(next_point) < 2:
			path.pop_front()
			next_point = path.front()
		
		if position.distance_to(next_point) > 2:
			velocity.x += clamp(velocity.x + (next_point - position).normalized().x * speed, -max_speed, max_speed)
		else:
			path.pop_front()
	
	velocity += gravity
	velocity = move_and_slide(velocity)



func notify_hit(amount: int = 1) -> void:
	print("I'm turret and imma die")
	_change_anim("dead")
	dead = true
	fire_timer.stop()
	idle_timer.stop()


func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()


func _on_DetectionArea_body_entered(body) -> void:
	if target == null:
		target=body


func _on_DetectionArea_body_exited(body) -> void:
	if body == target:
		target = null


func _on_Body_animation_finished() -> void:
	if body.animation == "dead":
		call_deferred("_remove")
	else:
		body.play("idle")

func _on_IdleTimer_timeout():
	var point: Vector2 = Vector2(rand_range(-wandering_range.x, wandering_range.x),rand_range(-wandering_range.y, wandering_range.y))
	path = pathfinding.get_simple_path(global_position, global_position + point)
