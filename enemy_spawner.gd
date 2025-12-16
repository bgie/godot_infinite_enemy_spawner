extends Timer

@export var enemies_container : Node2D
@export var player : Node2D
@export var maximum_enemies_count := 6
@export var spawn_distance := 10

var enemy_scene := preload("res://enemy.tscn")

func _on_timeout() -> void:
	check_to_spawn_enemies()

func _on_enemy_despawned() -> void:
	if get_tree():
		check_to_spawn_enemies()

func check_to_spawn_enemies() -> void:
	var enemies := get_tree().get_nodes_in_group("hostile")
	if len(enemies) < maximum_enemies_count:
		# spawn one at a time
		spawn_enemy()

func spawn_enemy() -> void:
	var enemy := enemy_scene.instantiate() as Node2D
	enemy.tree_exited.connect(_on_enemy_despawned)
	enemy.target = player
	var random_angle := randf_range(0, TAU)
	enemy.position = player.position + Vector2.from_angle(random_angle) * spawn_distance
	enemies_container.add_child(enemy)
