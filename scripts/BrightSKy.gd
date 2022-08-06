extends ColorRect

var on = false

func _process(delta):
	if not on and Globals.zone_2:
		$AnimationPlayer.play("show")
		on = true
