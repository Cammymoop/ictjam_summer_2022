extends Sprite

export var scroll_speed = 8

var scroll_at = 0
var go_up = 34000

export var stay_on = false

func _ready():
	var factor = (get_parent() as ParallaxLayer).motion_scale.x
	position.y -= go_up * factor
	print(factor)
	pass

func _process(delta):
	scroll_at += scroll_speed * delta
	region_rect.position.x = round(scroll_at)
	
	if not stay_on and Globals.elevation > 1030:
		visible = false
