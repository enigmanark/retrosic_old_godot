extends Area2D

export(int) var HP = 15;
export(int) var speed = 4;
export(float) var bulletTimeout = 0.5;
var bulletTimer = 0;
var canFire = true;
var velocity = Vector2();
var currentHP;
var touchEnabled = true;

func _ready():
	currentHP = HP;
	update_shieldGUI();
	if(get_parent().get_node("LevelController").System != "Android"):
		touchEnabled = false;
	
func get_touch_movement():
	velocity = Vector2();
	var upButtonPressed = get_parent().get_node("DirPadGUI/DirPad/UpButtonAligner/UpButton").pressed;
	var downButtonPressed = get_parent().get_node("DirPadGUI/DirPad/DownButtonAligner/DownButton").pressed;
	var leftButtonpressed = get_parent().get_node("DirPadGUI/DirPad/MiddleButtonAligner/LeftButton").pressed;
	var rightButtonPressed = get_parent().get_node("DirPadGUI/DirPad/MiddleButtonAligner/RightButton").pressed;
	if downButtonPressed:
		velocity.y += 1;
	if upButtonPressed:
		velocity.y -= 1;
	if leftButtonpressed:
		velocity.x -= 1;
	if rightButtonPressed:
		velocity.x += 1;
	velocity = velocity.normalized() * speed;
	
func get_movement():
	velocity = Vector2();
	if Input.is_action_pressed("down"):
		velocity.y += 1;
	if Input.is_action_pressed("up"):
		velocity.y -= 1;
	if Input.is_action_pressed("left"):
		velocity.x -= 1;
	if Input.is_action_pressed("right"):
		velocity.x += 1;
	velocity = velocity.normalized() * speed;

func get_touch_fire():
	var fireButtonPressed = get_parent().get_node("FireButton").pressed;
	if fireButtonPressed and canFire:
		var bulletScene = load("res://Prefabs/PlayerBullet.tscn");
		var bullet = bulletScene.instance();
		bullet.add_to_group("PlayerBullets");
		get_parent().add_child(bullet);
		bullet.position = Vector2(position.x, position.y);
		canFire = false;	

func get_fire():
	if Input.is_action_pressed("fire") and canFire:
		var bulletScene = load("res://Prefabs/PlayerBullet.tscn");
		var bullet = bulletScene.instance();
		bullet.add_to_group("PlayerBullets");
		get_parent().add_child(bullet);
		bullet.position = Vector2(position.x, position.y);
		canFire = false;

func proc_bulletTime(delta):
	if canFire == false:
		bulletTimer += delta;
		if bulletTimer >= bulletTimeout:
			bulletTimer = 0;
			canFire = true;

func _process(delta):
	if(!touchEnabled):
		 get_movement();
	else:
		 get_touch_movement();
	if(!touchEnabled):
		get_fire();
	else:
		get_touch_fire();
	proc_bulletTime(delta);
	position += velocity;

#Damage player
func _on_Player_area_entered(area):
	if area.is_in_group("EnemyBullets"):
		currentHP -= area.damage;
		print(currentHP);
		update_shieldGUI();
		area.queue_free();
		if(currentHP <= 0):
			get_tree().change_scene("res://Scenes/GameOver.tscn");
			
func update_shieldGUI():
	var healthDec = float(currentHP / float(HP));
	var healthPerc = float(healthDec * 100);
	get_parent().get_node("GUI/TopHUD/ShieldGUI/Progress").value = healthPerc;
	
