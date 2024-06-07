class_name LCG

var seed = 0
var modulus = 2**31 - 1  # A common choice for m
var multiplier = 1103515245  # A common choice for a
var increment = 12345  # A common choice for c

func _init(_seed = null):
	if _seed != null:
		seed = _seed

# Method to set the seed value
func set_seed(new_seed):
	seed = new_seed

func rand():
	seed = (multiplier * seed + increment) % modulus
	return seed

func randf():
	# Returns a random float between 0.0 and 1.0
	return float(rand()) / modulus

func rand_range(min, max):
	# Returns a random integer between min and max
	return min + rand() % (max - min + 1)
