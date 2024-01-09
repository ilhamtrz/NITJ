extends Control

@export var mainGameScene: PackedScene

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(mainGameScene)


func _on_exit_button_pressed():
	get_tree().quit()
