extends Node2D

const MOVE_SPEED := 100.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var hurt_area_2d: Area2D = $HurtArea2D

var enemy_hurt_this_attack := false

func _process(delta: float) -> void:
	var fire_button := Input.is_action_pressed("ui_accept")
	if fire_button and attack_cooldown_timer.is_stopped():
		# start attacking
		attack_cooldown_timer.start()
		animated_sprite_2d.stop()
		animated_sprite_2d.play("attack")
		hurt_area_2d.set_deferred("monitoring", true)

	if attack_cooldown_timer.is_stopped(): # when no attack in progress, animate idle or run
		var joystick_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var new_animation = "idle"
		
		if not joystick_direction.is_zero_approx():
			new_animation = "run"
			position += joystick_direction * delta * MOVE_SPEED
			
			if joystick_direction.x < 0:
				scale.x = -1
			elif joystick_direction.x > 0:
				scale.x = 1

		if animated_sprite_2d.animation != new_animation:
			animated_sprite_2d.play(new_animation)


func _on_hurt_area_2d_area_entered(area: Area2D) -> void:
	if enemy_hurt_this_attack:
		return # hurt only one enemy per attack
	var enemy : Node2D = area.get_parent()
	if enemy.has_method("take_damage"):
		enemy_hurt_this_attack = true
		enemy.take_damage(1, self.position)


func _on_attack_cooldown_timer_timeout() -> void:
	enemy_hurt_this_attack = false
	hurt_area_2d.set_deferred("monitoring", false)
