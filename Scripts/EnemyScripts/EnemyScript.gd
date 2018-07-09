extends Area2D

export(int) var HP = 2;
export(int) var BulletType = 1;
export(float) var BulletCooldown = 1.5;
export(int) var Speed = 75;
export(int) var Score = 100;

func _ready():
	pass

func _process(delta):
	position += Vector2(-1 * Speed * delta, 0);

func _on_VisibilityNotifier2D_screen_exited():
	queue_free();

func _on_Area2D_area_entered(area):
	if area.is_in_group("PlayerBullets"):
		HP -= area.damage;
		area.queue_free();
		if HP <= 0:
			var playerScore = get_node("../LevelController").Score;
			playerScore += Score;
			get_node("../GUI").get_child(0).get_child(2).get_child(1).text = str(playerScore);
			get_node("../LevelController").Score = playerScore;
			queue_free();

func spawn_bullet():
	if BulletType == 1:
		var bluebulletscene = load("res://Prefabs/BlueBullet.tscn");
		var bluebullet = bluebulletscene.instance();
		bluebullet.position = position;
		bluebullet.add_to_group("EnemyBullets");
		get_parent().add_child(bluebullet);
	elif BulletType == 2:
		var redbulletscene = load("res://Prefabs/RedBullet.tscn");
		var redbullet = redbulletscene.instance();
		redbullet.position = position;
		redbullet.add_to_group("EnemyBullets");
		get_parent().add_child(redbullet);
	elif BulletType == 3:
		var greenbulletscene = load("res://Prefabs/GreenBullet.tscn");
		var greenbullet = greenbulletscene.instance();
		greenbullet.position = position;
		greenbullet.add_to_group("EnemyBullets");
		get_parent().add_child(greenbullet);

func _on_Timer_timeout():
	spawn_bullet();
	get_node("Timer").wait_time = BulletCooldown;
	
