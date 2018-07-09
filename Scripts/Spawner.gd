extends Node2D

export(int) var Level = 1;
export(int) var Base = 15;
export(float) var Mod = 1.2;
var EnemyCount;
var screen_width;
var screen_height;

func _ready():
	var camera = get_node(NodePath("../Camera2D"));
	var view_port_width = get_viewport().get_visible_rect().size.x;
	var view_port_height = get_viewport().get_visible_rect().size.y;
	screen_height = view_port_height * camera.zoom.x;
	screen_width =  view_port_width * camera.zoom.y;

func increase_level():
	Level += 1;

func goto_nextLevel():
	var EnemyCount = Base;
	var currentLevel = 0;
	while(currentLevel < Level):
		EnemyCount *= 1.2;
		currentLevel += 1;

func instance_alien1():
	var enemyScene = load("res://Prefabs/Alien1.tscn");
	var enemy = enemyScene.instance();
	position_enemy(enemy);
	get_parent().add_child(enemy);
	enemy.add_to_group("Enemies");

func position_enemy(enemy):
	enemy.position = Vector2(int(screen_width) - 1,
		rand_range(0, int(screen_height)));

func _on_Timer_timeout():
	instance_alien1();
	#Set wait time to random between 1 and 4 on the timer
	get_child(0).wait_time = rand_range(1, 4);
	
	
