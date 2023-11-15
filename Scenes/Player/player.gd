extends CharacterBody2D

@export var movement_speed = 200.0
@export var hp = 100.0

#Attacks
var iceSpear = preload("res://Scenes/Player/spear.tscn")

#AttackNodes
@onready var iceSpearTimer = %IceSpearTimer
@onready var iceSpearAttackTimer = %IceSpearAttackTimer

#IceSpear
var icespear_ammo = 1
var icespear_baseammo = 1
var icespear_attackspeed = 1.5
var icespear_level = 1

#Enemy Related
var enemy_close = []

@onready var sprite = $PlayerImage
@onready var walkTimer = %walkTimer

func _ready():
	attack()

func _physics_process(_delta):
	movement()
	

func attack():
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attackspeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()

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


func _on_hurt_box_hurt(damage):
	hp -= damage
	print(hp)

func _on_ice_spear_timer_timeout():
	icespear_ammo += icespear_baseammo
	iceSpearAttackTimer.start()


func _on_ice_spear_attack_timer_timeout():
	if icespear_ammo > 0:
		print("player position: ", position )
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.position = position
		print("ice spear position: ", icespear_attack.position)
		icespear_attack.target = get_random_target()
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
