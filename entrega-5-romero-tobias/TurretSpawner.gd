extends Area2D
var rng = RandomNumberGenerator.new()
export (PackedScene) var turret
export var spawners = 3

func spawn_turrets():
	rng.randomize()
	for i in spawners:
		var turret_instance = turret.instance()
		var spawner_col = $CollisionShape2D
		var obj_pos_x = rng.randf_range(global_position.x - spawner_col.shape.get_extents().x , global_position.x + spawner_col.shape.get_extents().x)
		var obj_pos_y = rng.randf_range(global_position.y - spawner_col.shape.get_extents().y , global_position.y + spawner_col.shape.get_extents().y - 130)
		turret_instance.set_values(self, Vector2(obj_pos_x , obj_pos_y), self)
	var ultima_torre = turret.instance()
	ultima_torre.set_values(self, Vector2(2409,285),self)
