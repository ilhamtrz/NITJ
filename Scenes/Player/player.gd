extends CharacterBody2D

@export var movement_speed = 200.0
@export var hp = 100.0
@onready var sprite = $PlayerImage
@onready var walkTimer = %walkTimer

func _physics_process(_delta):
	movement()
	

func movement():
	# move input
	var direction = Input.get_vector("player_left","player_right","player_up","player_down")
	
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
	
	if direction != Vector2.ZERO:
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	
	velocity = direction.normalized() * movement_speed
	move_and_slide()
