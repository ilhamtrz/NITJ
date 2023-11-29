extends CharacterBody2D

@export var movement_speed = 50.0
@export var hp = 20.0
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $EnemyImage

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	velocity += knockback
	move_and_slide()
	
	if direction.x > 0.1:
		sprite.flip_h = false
	elif direction.x < -0.1:
		sprite.flip_h = true
		

func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		queue_free()
