extends Node2D

var powerup_1 = preload("res://scenes/MagicPowerup.tscn")
var powerup_comet = preload("res://scenes/MagicCometPowerup.tscn")
var player: RigidBody2D = null

var how_many = 6
var spawn_available = true

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0] as RigidBody2D
	if not player:
		print_debug("Can't find player")
		set_process(false)
		queue_free()

func _process(delta):
	var current_powerups = clear_far_powerups()
	
	if spawn_available and current_powerups < how_many:
		spawn_a_powerup()

func spawn_a_powerup() -> void:
	var at_y = player.global_position.y
	var at_x = rand_range(Globals.LEFT_BOUND, Globals.RIOGHT_BOUND)
	
	var velocity = player.linear_velocity.y
	
	var target_speed = -450 if Globals.fw_level < 2 else -700
	
	var comet = velocity < target_speed and rand_range(0, 1) > 0.4
	if velocity < -1100:
		comet = true
	
	if comet and Globals.elevation > 130:
		at_y += velocity * 1.3
		
		var powerup = powerup_comet.instance()
		powerup.position = Vector2(at_x, at_y)
		powerup.speed = (-velocity) - 60
		powerup.h_speed = rand_range(-45, 45)
		add_child(powerup)
	else:
		at_y += velocity * 2.2
		
		if at_y > 800:
			at_y = 750
		
		var powerup = powerup_1.instance()
		powerup.position = Vector2(at_x, at_y)
		add_child(powerup)
		
		powerup.h_speed = round(rand_range(-4, 4))
		if velocity > 0:
			if rand_range(0, 1) > 0.5:
				powerup.side_wave = true
				powerup.wave_height = 28
		else:
			if rand_range(0, 1) > 0.92:
				powerup.side_wave = true
				powerup.wave_height = 50
	
	spawn_available = false
	$SpawnLimiter.start()

# Returns the number of active powerups left
func clear_far_powerups() -> int:
	var total_powerups: int = get_child_count()
	
	var velocity = player.linear_velocity.y
	var direction = sign(velocity)
	
	for child in get_children():
		var c: = child as Node2D
		if not c:
			continue
		var y_diff: = c.global_position.y - player.global_position.y
		
		if abs(y_diff) > 1440:
			if c.type == "comet" and abs(y_diff) < 3500:
				if sign(y_diff) == direction and c.is_on_screen():
					continue
			elif sign(y_diff) == direction:
				continue
			#defintely off screen
			total_powerups -= 1
			c.queue_free()
	
	return total_powerups


func _on_SpawnLimiter_timeout():
	spawn_available = true
