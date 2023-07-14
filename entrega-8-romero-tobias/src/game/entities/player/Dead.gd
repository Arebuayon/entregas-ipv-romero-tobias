extends AbstractState

func enter():
	character._play_animation("dead", false)

func update(delta):
	print("dead")
	character._handle_dead()
	character._apply_movement()


