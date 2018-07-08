extends Area2D

export(int) var HP = 2;
export(int) var Speed = 75;

func _ready():
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free();

func _on_Area2D_area_entered(area):
	if area.is_in_group("PlayerBullets"):
		HP -= area.damage;
		area.queue_free();
		if HP <= 0:
			queue_free();
