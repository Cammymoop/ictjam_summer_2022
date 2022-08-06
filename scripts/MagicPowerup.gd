extends Node2D

var h_speed: float = 3
var wave_height: float = 6

onready var start_x = position.x
onready var start_y = position.y
var livetime = 0
var collected = false

var collect_value = 45

var side_wave = false

var type = "regular"

func _on_Area2D_body_entered(body: PhysicsBody2D):
	if not collected and body.has_method("collect"):
		collected = true
		body.collect(collect_value)
		$Particles2D.emitting = false
		$AnimationPlayer.play("HideParticles")
		$Explood.emitting = true
		$DeathTimer.start()

func _process(delta):
	livetime += delta
	if side_wave:
		position.x = start_x + (sin(livetime*2) * wave_height * 10)
	else:
		position.x += h_speed * 10 * delta
		position.y = start_y + (sin(livetime*2) * wave_height * 10)
		
		if h_speed > 0:
			if position.x > Globals.RIOGHT_BOUND + 60:
				queue_free()
		elif h_speed < 0:
			if position.x < Globals.LEFT_BOUND - 60:
				queue_free()


func _on_DeathTimer_timeout():
	queue_free()
