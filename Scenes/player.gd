extends CharacterBody2D

const speed = 200.0

func _process(_delta):
	
	# move input
	var direction = Input.get_vector("player_left","player_right","player_up","player_down")
	velocity = direction.normalized() * speed
	move_and_slide()
