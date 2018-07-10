extends Area2D

export(int) var HP = 15;
export(int) var speed = 4;
export(float) var bulletTimeout = 0.5;
var bulletTimer = 0;
var canFire = true;
var velocity = Vector2();
var currentHP;

func _ready():
	currentHP = HP;
	update_shieldGUI();
	
func get_movement():
	velocity = Vector2();
	if Input.is_action_pressed("down"):
		velocity.y += 1;
	elif Input.is_action_pressed("up"):
		velocity.y -= 1;
	elif Input.is_action_pressed("left"):
		velocity.x -= 1;
	elif Input.is_action_pressed("right"):
		velocity.x += 1;
	velocity = velocity.normalized() * speed;

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
	get_movement();
	get_fire();
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
	
