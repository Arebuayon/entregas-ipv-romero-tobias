extends Control

export (PackedScene) var turret_scene
var pathfinding

func _ready():
	call_deferred("_initialize")

func _initialize():
	if pathfinding == null:
		return
	for i in 3:
		var turret_instance = turret_scene.instance()
		
		var turret_pos:Vector2 = Vector2(
			rand_range(rect_position.x, rect_position.x + rect_size.x),
			rand_range(rect_position.y, rect_position.y + rect_size.y)
			)
		
		turret_instance.initialize(self, turret_pos, self)
		turret_instance.pathfinding = pathfinding
		
