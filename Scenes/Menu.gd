extends Node

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_pressed("fire"):
		get_tree().change_scene("res://Scenes/Level1.tscn");
