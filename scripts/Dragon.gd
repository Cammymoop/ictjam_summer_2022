extends AnimatedSprite

var player: Node2D = null

var scroll_factor = 0.25

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0] as Node2D
	
	play("fly")
	
	frame = round(rand_range(0, frames.get_frame_count("fly") - 1))

func _process(delta):
	if player:
		var adjusted_y = player.global_position.y * scroll_factor + 350
		# I dont know why 350
		if abs(adjusted_y - position.y) > 800:
			return # dont move when off screen
	if flip_h:
		position.x += 80 * delta
	else:
		position.x -= 80 * delta
