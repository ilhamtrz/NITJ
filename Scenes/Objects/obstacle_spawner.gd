extends Node2D

var LCG = preload("res://Scripts/LCG.gd")

# Assuming you have a PackedScene for the obstacle
@export var obstacle_scene:PackedScene
@export var number_of_obstacles = 5  # Default number of obstacles
@export var min_distance_between_obstacles = 100  # Minimum distance between obstacles

var lcg_instance = LCG.new(GlobalSettings.seed)
var rng = RandomNumberGenerator.new()
var obstacle_positions = []

func _ready():
	spawn_obstacles(number_of_obstacles)

func spawn_obstacles(amount: int):
	var seed = GlobalSettings.seed
	for i in range(amount):
		var position = get_random_position(seed)
		while not is_position_valid(position):
			seed = seed + 1
			position = get_random_position(seed)
		var obstacle_instance = obstacle_scene.instantiate()
		obstacle_instance.position = position
		print("spawned position: {}", obstacle_instance.position)
		add_child(obstacle_instance)
		obstacle_positions.append(position)
		seed = seed + 1

func get_random_position(seed: int) -> Vector2:
	rng.seed = hash(seed)
	var x = rng.randf_range(0, get_viewport_rect().size.x)
	var y = rng.randf_range(0, get_viewport_rect().size.y)
	return Vector2(x, y)

func is_position_valid(position: Vector2) -> bool:
	for existing_position in obstacle_positions:
		if position.distance_to(existing_position) < min_distance_between_obstacles:
			return false
	return true
