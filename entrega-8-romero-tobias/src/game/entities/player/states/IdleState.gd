extends AbstractState


func enter():
	character._play_animation("idle")


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left") || event.is_action_pressed("move_right"):
		emit_signal("finished", "walk")
	if event.is_action_pressed("jump"):
		emit_signal("finished","jump")
	

func update(delta: float) -> void:
	character._handle_move_input()
	character._handle_cannon_actions()
	character._handle_deacceleration()
	character._apply_movement()
	if (character.velocity.x != 0):
		emit_signal("finished", "walk")		
	if (character.is_on_floor()):
		character._play_animation("idle")
	else:
		character._play_animation('jump')

func handle_event(event: String, value = null) -> void:
	match event:
		"hit":
			character._handle_hit(value)
		"healed":
			character._handle_heal(value)
		"dead":
			emit_signal("finished","dead")
