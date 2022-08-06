extends RigidBody2D

var base_thrust = 200.0
var turn_force = 20000.0

var shove_force = 700.0

var fireworks_level = 1

var powerup_thrust_factor = 2.4

var thrust_on = false

var FLOOR_HEIGHT = 900

var powerup_time = 3

onready var current_emitter = $WeakParticles

func _physics_process(delta):
	applied_force = Vector2.ZERO
	applied_torque = 0
	
	$PowerParticles.emitting = false
	var random_factor = rand_range(0, 1)
	var thrust_now = Input.is_action_pressed("thrust")
	thrust_now = thrust_now and random_factor > (.5 if fireworks_level < 2 else .2)
	
	var up = Vector2.UP.rotated(rotation)
	
	
	if thrust_now:
		applied_force = base_thrust * up
		current_emitter.emitting = true
		thrust_on = true
	else:
		current_emitter.emitting = false
		thrust_on = false
	
	if Input.is_action_pressed("thrust"):
		if powerup_time > 0:
			powerup_time = max(0, powerup_time - delta)
			applied_force *= powerup_thrust_factor
			$PowerParticles.emitting = true
	
	if Input.is_action_pressed("rotate_left"):
		applied_torque -= turn_force
	elif Input.is_action_pressed("rotate_right"):
		applied_torque += turn_force
	else:
		var cur_angle = rotation
		if cur_angle > PI:
			cur_angle -= 2*PI
		
		if abs(cur_angle) < PI/32:
			rotation = 0
	
	if position.x < Globals.LEFT_BOUND:
		if linear_velocity.x < -200:
			applied_force.x += shove_force * 3
		elif linear_velocity.x < 70:
			applied_force.x += shove_force
	if position.x > Globals.RIOGHT_BOUND:
		if linear_velocity.x > 200:
			applied_force.x -= shove_force * 3
		elif linear_velocity.x > -70:
			applied_force.x -= shove_force
	
	if Globals.elevation > 900 and fireworks_level == 1:
		fireworks_level = 2
		Globals.fw_level = 2
		$WeakParticles.emitting = false
		current_emitter = $PowerfulParticles
	
	

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		restart()
	
	Globals.elevation = - ((position.y + 25) - FLOOR_HEIGHT)
	Globals.elevation = round(max(0, Globals.elevation / 34))
	
	Globals.fairy_dust_available = powerup_time > 0
	
	Globals.speed = linear_velocity.y
	
	if not Globals.zone_2 and Globals.elevation > 1036:
		Globals.zone_2 = true
		
		var p = $Puff.process_material as ParticlesMaterial
		p.initial_velocity = (-Globals.speed) + 90
		$Puff.emitting = true

func restart() -> void:
	Globals.reset()
	get_tree().reload_current_scene()

func collect(value) -> void:
	powerup_time += value/10
