extends Area2D

@export var damage = 1

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

func temp_disable():
	collision.call_deferred("set","disabled",true)



func _on_disable_timer_timeout():
	collision.call_deferred("set","disabled",false)
