extends AbstractState

func enter():
	character._play_animation("jump", false)
	character.snap_vector = Vector2.ZERO

func update(delta):
	character._handle_jump()
	character._handle_cannon_actions()
	character._handle_move_input()
	character._apply_movement()
	if character.is_on_floor():
		if (character.move_direction == 0):
			emit_signal("finished","idle")
		else:
			emit_signal("finished","walk") 
	


func handle_event(event: String, value = null) -> void:
	match event:
		"hit":
			character._handle_hit(value)
		"healed":
			character._handle_heal(value)
		"dead":
			emit_signal("finished","dead")
