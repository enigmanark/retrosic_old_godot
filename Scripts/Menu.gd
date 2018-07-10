extends Node

func _ready():
	pass

func _process(delta):
	var startPressed = get_node("StartButton").pressed;
	if(startPressed):
		get_tree().change_scene("res://Scenes/Level1.tscn");
