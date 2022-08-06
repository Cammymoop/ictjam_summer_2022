extends Control

func _process(delta):
	if Globals.fairy_dust_available:
		visible = true
	else:
		visible = false
