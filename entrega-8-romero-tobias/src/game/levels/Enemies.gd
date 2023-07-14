extends Node2D
export (NodePath) var pathfinding: NodePath

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if pathfinding.is_empty():
		return
	
	var pathfinder: PathfindAstar = get_node(pathfinding)
	if pathfinder == null:
		return
	for child in get_children():
		if (!child is TileMap):
			child.pathfinding = pathfinder
