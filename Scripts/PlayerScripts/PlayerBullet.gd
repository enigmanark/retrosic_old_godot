extends Area2D

export(int) var speed = 300;
export(int) var damage = 1;

func _ready():
	pass
	
func _process(delta):
	add_to_group("PlayerBullets");
	position += Vector2(speed * delta, 0);


func _on_VisibilityNotifier2D_screen_exited():
	queue_free();
