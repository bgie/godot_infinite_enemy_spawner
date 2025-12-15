extends Node2D

@export var target : Node2D = null

const MOVE_SPEED := 40.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	if target:
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
