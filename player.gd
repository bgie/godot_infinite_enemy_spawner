extends Node2D

const MOVE_SPEED := 100.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer

func _process(delta: float) -> void:
	var joystick_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var fire_button := Input.is_action_pressed("ui_accept")
	var new_animation = "idle"
	
	if not joystick_direction.is_zero_approx():
		new_animation = "run"
		position += joystick_direction * delta * MOVE_SPEED
		
		if joystick_direction.x < 0:
			scale.x = -1
		elif joystick_direction.x > 0:
			scale.x = 1

	if fire_button and attack_cooldown_timer.is_stopped():
		# start attacking
		attack_cooldown_timer.start()
		animated_sprite_2d.play("attack")
	elif attack_cooldown_timer.is_stopped(): # when no attack in progress, animate idle or run
		if animated_sprite_2d.animation != new_animation:
			animated_sprite_2d.play(new_animation)
