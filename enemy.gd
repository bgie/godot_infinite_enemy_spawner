extends Node2D

@export var target : Node2D = null
@export var hp := 3

const MOVE_SPEED := 40.0
const KNOCKBACK_SPEED := 120.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var knockback_timer: Timer = $KnockbackTimer

var knockback_direction := Vector2.ZERO

func _process(delta: float) -> void:
	if knockback_timer.time_left:
		self.position += knockback_direction * KNOCKBACK_SPEED * delta

	elif target and not animation_player.is_playing() and hp > 0:
		var target_vector := target.position - self.position
		var target_distance := target_vector.length()
		var maximum_move_distance := MOVE_SPEED * delta
		
		# Check if we are close enough to reach the enemy this frame
		if target_distance < maximum_move_distance:
			# We can reach the enemy this frame
			self.position = target.position
		else:
			# Move towards our enemy at the maximum allowed speed
			var target_direction := target_vector / target_distance
			self.position += target_direction * maximum_move_distance

		if target_vector.x < 0:
			scale.x = -1
		elif target_vector.x > 0:
			scale.x = 1


func take_damage(amount: int, source: Vector2) -> void:
	if hp == 0:
		return
	hp = max(hp - amount, 0)
	
	knockback_timer.start()
	knockback_direction = (position - source).normalized()
	
	animation_player.stop()
	if hp > 0:
		animation_player.play("hurt")
	else:
		animation_player.play("die")
