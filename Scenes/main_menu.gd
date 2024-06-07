extends Control
# Import class LCG
var LCG = preload("res://Scripts/LCG.gd")

@export var mainGameScenes: Array[PackedScene] = []

@onready var seed_text = get_node("MarginContainer/VBoxContainer/LineEdit")
# Create a new instance of RandomNumberGenerator
#var rng = RandomNumberGenerator.new()
#Set the seed value

# Initialize the seed value
#var seed_value = 1

# Create an instance of the LCG class with the seed value


func _ready():
	seed_text.grab_focus()

func _on_play_button_pressed():
	GlobalSettings.seed = int(seed_text.text)
	var lcg_instance = LCG.new(GlobalSettings.seed)
	print("Seed Value: ", GlobalSettings.seed)
	var sceneIndex = lcg_instance.rand_range(0, mainGameScenes.size() - 1)
	print("Stage variation Selected:",sceneIndex)
	var selectedScene = mainGameScenes[sceneIndex]
	get_tree().change_scene_to_packed(selectedScene)

func _on_exit_button_pressed():
	get_tree().quit()
