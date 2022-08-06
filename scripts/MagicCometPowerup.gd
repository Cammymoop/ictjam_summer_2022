extends Node2D

var speed = 800
var h_speed = 0

var collected = false

var collect_value = 70

var type = "comet"

func _ready():
	var parts = $Particles2D.process_material as ParticlesMaterial
	parts.initial_velocity = speed * 9/8
	parts.damping = speed * 7/8
	
	$Explood.process_material.initial_velocity = speed + 160

func is_on_screen() -> bool:
	return $VisibilityNotifier2D.is_on_screen()

func _process(delta):
	position.y -= speed * delta
	position.x += h_speed * delta


func _on_Area2D_body_entered(body):
	if not collected and body.has_method("collect"):
		collected = true
		body.collect(collect_value)
		$Particles2D.emitting = false
		$AnimationPlayer.play("HideParticles")
		$Explood.emitting = true
		$DeathTimer.start()


func _on_DeathTimer_timeout():
	queue_free()
