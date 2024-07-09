extends Node2D

var LCG = preload("res://Scripts/LCG.gd")

# Assuming you have a PackedScene for the obstacle
@export var obstacle_scene:PackedScene
@export var number_of_obstacles = 30  # Default number of obstacles
@export var min_distance_between_obstacles = 300  # Minimum distance between obstacles

var lcg_instance = LCG.new(GlobalSettings.seed)
var rng = RandomNumberGenerator.new()
var obstacle_positions = []

func _ready():
	spawn_obstacles(number_of_obstacles)

func spawn_obstacles(amount: int):
	var seed = GlobalSettings.seed
	for i in range(amount):
		var position = get_valid_position(seed)
		var obstacle_instance = obstacle_scene.instantiate()
		obstacle_instance.position = position
		add_child(obstacle_instance)
		obstacle_positions.append(position)
		seed = seed + 1

func get_valid_position(seed: int) -> Vector2:
	var position = get_random_position(seed)
	var attempts = 0
	while not is_position_valid(position) and attempts < 100:
		position = get_random_position(seed + attempts)
		attempts += 1
	if attempts == 100:
		print("Could not find a valid position after 100 attempts, placing it anyway.")
	return position

func get_random_position(seed: int) -> Vector2:
	rng.seed = hash(seed)
	var x = rng.randf_range(0, get_viewport_rect().size.x)
	var y = rng.randf_range(0, get_viewport_rect().size.y)
	return Vector2(x, y)

func is_position_valid(position: Vector2) -> bool:
	var temp_obstacle = obstacle_scene.instantiate()
	temp_obstacle.position = position
	add_child(temp_obstacle)
	var space_state = get_world_2d().direct_space_state
	var shape = temp_obstacle.get_node("ProximityCollision").shape
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape_rid = shape.get_rid()
	query.transform = temp_obstacle.global_transform
	query.margin = 0.1
	var result = space_state.intersect_shape(query)
	remove_child(temp_obstacle)
	temp_obstacle.queue_free()
	return result.size() == 0
