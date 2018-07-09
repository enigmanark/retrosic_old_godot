extends Sprite

export(int) var speed = 130;
var hillSprite2;

func _ready():
	hillSprite2 = get_node("../HillySprite2");
	hillSprite2.position = Vector2(position.x + hillSprite2.get_texture().get_width(), position.y);
	
func _process(delta):
	position += Vector2(-speed * delta, 0);
	hillSprite2.position += Vector2(-speed * delta, 0);
	if (position.x + get_texture().get_width()) < 0:
		position = Vector2(hillSprite2.position.x + hillSprite2.get_texture().get_width(), position.y);
	if(hillSprite2.position.x + get_texture().get_width()) < 0:
		hillSprite2.position = Vector2(position.x + hillSprite2.get_texture().get_width(), position.y);
		
