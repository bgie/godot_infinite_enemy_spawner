extends Sprite2D

var tile_size = 640

func _process(_delta):
	position = (get_tree().root.get_camera_2d().get_screen_center_position() / tile_size).round() * tile_size
