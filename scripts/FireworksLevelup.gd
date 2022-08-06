extends Control

var level_now = 0

func _process(delta):
	if Globals.fw_level > level_now:
		set_the_text()
		level_now = Globals.fw_level
		visible = true
		$Timer.start()

func set_the_text() -> void:
	$Label.text = "Fireworks Level\n" + str(level_now) + " -> " + str(Globals.fw_level)


func _on_Timer_timeout():
	visible = false
