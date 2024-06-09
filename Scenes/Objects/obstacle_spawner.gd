extends Node2D

var LCG = preload("res://Scripts/LCG.gd")

# Assuming you have a PackedScene for the obstacle
@export var obstacle_scene:PackedScene
@export var number_of_obstacles = 5  # Default number of obstacles

var lcg_instance = LCG.new(GlobalSettings.seed)
var rng = RandomNumberGenerator.new()


func _ready():
	spawn_obstacles(number_of_obstacles)

func spawn_obstacles(amount: int):
	var seed = GlobalSettings.seed
	for i in range(amount):
		var obstacle_instance = obstacle_scene.instantiate()
		obstacle_instance.position = get_random_position(seed)
		add_child(obstacle_instance)
		seed = seed + 1

func get_random_position(seed: int) -> Vector2:
	rng.seed = hash(seed)
	var x = rng.randf_range(0, get_viewport_rect().size.x)
	var y = rng.randf_range(0, get_viewport_rect().size.y)
	return Vector2(x, y)
