extends Node2D

@export var enemyTier1: Array[Resource] = []
@export var enemyTier2: Array[Resource] = []
@export var enemyTier3: Array[Resource] = []
@export var enemyTier4: Array[Resource] = []
@export var enemyFinal: Array[Resource] = []

@export var spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")

@export var time = 0
signal changetime(time)

func _ready():
	connect("changetime",Callable(player,"change_time"))
	
	var rng = RandomNumberGenerator.new()
	# Set the seed value
	rng.seed = hash(GlobalSettings.seed)
	
	var selectedTier1 = rng.randi_range(0, enemyTier1.size() - 1)
	var selectedTier2 = rng.randi_range(0, enemyTier2.size() - 1)
	var selectedTier3 = rng.randi_range(0, enemyTier3.size() - 1)
	var selectedTier4 = rng.randi_range(0, enemyTier4.size() - 1)
	var selectedTierFinal = rng.randi_range(0, enemyFinal.size() - 1)
	
	print("Tier 1 selected:",selectedTier1)
	print("Tier 2 selected:",selectedTier2)
	print("Tier 3 selected:",selectedTier3)
	print("Tier 4 selected:",selectedTier4)
	print("Tier Final selected:",selectedTierFinal)
	
	# initialize spawn_infos
	# Initialize Spawn_info instance 1
	var spawn1 = Spawn_info.new()
	spawn1.time_start = 0
	spawn1.time_end = 30
	spawn1.enemy = enemyTier1[selectedTier1]  # Set the path to your enemy resource
	spawn1.enemy_num = 1
	spawn1.enemy_spawn_delay = 0
	spawns.append(spawn1)
	
	# Initialize Spawn_info instance 2
	var spawn2 = Spawn_info.new()
	spawn2.time_start = 30
	spawn2.time_end = 210
	spawn2.enemy = enemyTier1[selectedTier1]  # Set the path to your enemy resource
	spawn2.enemy_num = 2
	spawn2.enemy_spawn_delay = 0
	spawns.append(spawn2)
	
	# Initialize Spawn_info instance 3
	var spawn3 = Spawn_info.new()
	spawn3.time_start = 60
	spawn3.time_end = 180
	spawn3.enemy = enemyTier2[selectedTier2]  # Set the path to your enemy resource
	spawn3.enemy_num = 1
	spawn3.enemy_spawn_delay = 3
	spawns.append(spawn3)
	
	# Initialize Spawn_info instance 4
	var spawn4 = Spawn_info.new()
	spawn4.time_start = 180
	spawn4.time_end = 210
	spawn4.enemy = enemyTier2[selectedTier2]  # Set the path to your enemy resource
	spawn4.enemy_num = 1
	spawn4.enemy_spawn_delay = 2
	spawns.append(spawn4)
	
	# Initialize Spawn_info instance 5
	var spawn5 = Spawn_info.new()
	spawn5.time_start = 210
	spawn5.time_end = 240
	spawn5.enemy = enemyTier2[selectedTier2]  # Set the path to your enemy resource
	spawn5.enemy_num = 2
	spawn5.enemy_spawn_delay = 0
	spawns.append(spawn5)
	
	# Initialize Spawn_info instance 6
	var spawn6 = Spawn_info.new()
	spawn6.time_start = 240
	spawn6.time_end = 270
	spawn6.enemy = enemyTier3[selectedTier3]  # Set the path to your enemy resource
	spawn6.enemy_num = 1
	spawn6.enemy_spawn_delay = 0
	spawns.append(spawn6)
	
	# Initialize Spawn_info instance 7
	var spawn7 = Spawn_info.new()
	spawn7.time_start = 240
	spawn7.time_end = 240
	spawn7.enemy = enemyTier4[selectedTier4]  # Set the path to your enemy resource
	spawn7.enemy_num = 1
	spawn7.enemy_spawn_delay = 0
	spawns.append(spawn7)
	
	# Initialize Spawn_info instance 8
	var spawn8 = Spawn_info.new()
	spawn8.time_start = 270
	spawn8.time_end = 300
	spawn8.enemy = enemyTier2[selectedTier2]  # Set the path to your enemy resource
	spawn8.enemy_num = 4
	spawn8.enemy_spawn_delay = 0
	spawns.append(spawn8)
	
	# Initialize Spawn_info instance 9
	var spawn9 = Spawn_info.new()
	spawn9.time_start = 300
	spawn9.time_end = 300
	spawn9.enemy = enemyFinal[selectedTierFinal]  # Set the path to your enemy resource
	spawn9.enemy_num = 1
	spawn9.enemy_spawn_delay = 0
	spawns.append(spawn9)
   

func _on_timer_timeout():
	time += 1
	var enemy_spawns = spawns
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				var counter = 0
				if counter < i.enemy_num:
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.global_position = get_random_position()
					add_child(enemy_spawn)
					counter += 1
	emit_signal("changetime",time)

func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1,1.4)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var pos = ["up","down","left","right"].pick_random()
	
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
	
	var x_spawn = randf_range(spawn_pos1.x,spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y,spawn_pos2.y)
	
	return Vector2(x_spawn,y_spawn)
