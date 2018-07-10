extends Node2D

export(int) var Level = 0;
export(int) var Base = 10;
export(float) var Mod = 1.3;
var Score = 0;
var WavesToSpawn;
var ChanceSpawn1 = 100;
var ChanceSpawn2 = 50;
var ChanceSpawn3 = 0;
var ChanceSpawn4 = 0;
var ChanceSpawn5 = 0;
var screen_width;
var screen_height;
var alien1Weight;
var alien2Weight;
var alien3Weight;
var destroyerWeight;

func _ready():
	var camera = get_node(NodePath("../Camera2D"));
	var view_port_width = get_viewport().get_visible_rect().size.x;
	var view_port_height = get_viewport().get_visible_rect().size.y;
	screen_height = view_port_height * camera.zoom.x;
	screen_width =  view_port_width * camera.zoom.y;
	#Score
	get_node("../GUI").get_child(0).get_child(2).get_child(1).text = "0";
	loadLevel(1);

func _process(delta):
	if WavesToSpawn == 0 and is_level_end():
		if(!loadLevel(Level+1)):
			get_tree().change_scene("res://Scenes/GameOver.tscn");

func loadLevel(lvl):
	if lvl == 1:
		Level = 1;
		setup_level1();
	elif lvl == 2:
		Level = 2;
		setup_level2();
	elif lvl == 3:
		Level = 3;
		setup_level3();
	elif lvl == 4:
		Level = 4;
		setup_level4();
	elif lvl == 5:
		Level = 5;
		setup_level5();
	else:
		return false;
	setup_enemyCount();
	get_node("../GUI").get_child(0).get_child(3).get_child(1).text = str(WavesToSpawn);
	return true;

func setup_enemyCount():
	#Increase enemy count dynamically based on level
	WavesToSpawn = Base;
	var currentLevel = 0;
	#Iterate over each level and increase enemy count until we get to the right level we're on
	while(currentLevel < Level):
		WavesToSpawn *= Mod;
		currentLevel += 1;
	WavesToSpawn = int(WavesToSpawn);
	
func position_enemy(enemy):
	enemy.position = Vector2(int(screen_width) - 1, rand_range(0, int(screen_height)));

func spawn_enemy():
	var roll = rand_range(1, 100);
	if(roll <= destroyerWeight):
		instance_desteroyer();
	elif(roll <= alien3Weight):
		instance_alien3();
	elif(roll <= alien2Weight):
		instance_alien2();
	elif(roll <= alien1Weight):
		instance_alien1();

func setup_level1():
	alien1Weight = 100;
	alien2Weight = 25;
	alien3Weight = 0;
	destroyerWeight = 0;
	get_node("../GUI").get_child(0).get_child(1).get_child(1).text = "1";
	
func setup_level2():
	alien1Weight = 100;
	alien2Weight = 40;
	alien3Weight = 5;
	destroyerWeight = 0;
	ChanceSpawn3 = 10;
	get_node("../GUI").get_child(0).get_child(1).get_child(1).text = "2";
	
func setup_level3():
	alien1Weight = 100;
	alien2Weight = 55;
	alien3Weight = 12;
	destroyerWeight = 0;
	ChanceSpawn2 = 75;
	ChanceSpawn3 = 15;
	get_node("../GUI").get_child(0).get_child(1).get_child(1).text = "3";
	
func setup_level4():
	alien1Weight = 100;
	alien2Weight = 65;
	alien3Weight = 20;
	ChanceSpawn3 = 25;
	get_node("../GUI").get_child(0).get_child(1).get_child(1).text = "4";
	
func setup_level5():
	alien1Weight = 100;
	alien2Weight = 70;
	alien3Weight = 25;
	ChanceSpawn4 = 10;
	get_node("../GUI").get_child(0).get_child(1).get_child(1).text = "5";

func instance_alien1():
	var enemyScene = load("res://Prefabs/Alien1.tscn");
	var enemy = enemyScene.instance();
	position_enemy(enemy);
	get_parent().add_child(enemy);
	enemy.add_to_group("Enemies");

func instance_alien2():
	var enemyScene = load("res://Prefabs/Alien2.tscn");
	var enemy = enemyScene.instance();
	position_enemy(enemy);
	get_parent().add_child(enemy);
	enemy.add_to_group("Enemies");

func instance_alien3():
	var enemyScene = load("res://Prefabs/Alien3.tscn");
	var enemy = enemyScene.instance();
	position_enemy(enemy);
	get_parent().add_child(enemy);
	enemy.add_to_group("Enemies");

func instance_destroyer():
	var destroyerScene = load("res://Prefabs/Destroyer.tscn");
	var destroyer = destroyerScene.instance();
	position_enemy(destroyer);
	get_parent().add_child(destroyer);
	destroyer.add_to_group("Enemies");

func is_level_end():
	if get_tree().get_nodes_in_group("Enemies").size() == 0:
		return true;
	else:
		return false;

func _on_Timer_timeout():
	if WavesToSpawn > 0:
		var roll = rand_range(1, 100);
		if roll <= ChanceSpawn5:
			for i in range(5):
				spawn_enemy();
		elif roll <= ChanceSpawn4:
			for i in range(4):
				spawn_enemy();
		elif roll <= ChanceSpawn3:
			for i in range(3):
				spawn_enemy();
		elif roll <= ChanceSpawn2:
			for i in range(2):
				spawn_enemy();
		elif roll <= ChanceSpawn1:
			spawn_enemy();
		WavesToSpawn -= 1;
		get_node("../GUI").get_child(0).get_child(3).get_child(1).text = str(WavesToSpawn);
		#Set wait time to random between 1 and 4 on the timer
		get_child(0).wait_time = rand_range(1, 4);