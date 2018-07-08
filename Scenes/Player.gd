extends Area2D

export(int) var speed = 4;
export(float) var bulletTimeout = 0.5;
var bulletTimer = 0;
var canFire = true;
var velocity = Vector2();

func _ready():
	pass;
	
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
	
func _on_Area2D_body_entered(body):
	pass # replace with function body
