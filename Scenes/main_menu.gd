extends Control

@export var mainGameScenes: Array[PackedScene] = []
# Create a new instance of RandomNumberGenerator
var rng = RandomNumberGenerator.new()
#Set the seed value


func _on_play_button_pressed():
	rng.seed = hash("123")
	var sceneIndex = rng.randi_range(0, mainGameScenes.size() - 1)
	print("Stage variation Selected:",sceneIndex)
	var selectedScene = mainGameScenes[sceneIndex]
	get_tree().change_scene_to_packed(selectedScene)

func _on_exit_button_pressed():
	get_tree().quit()
