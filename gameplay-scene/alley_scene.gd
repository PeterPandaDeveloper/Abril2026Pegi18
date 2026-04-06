extends Node2D

var hold_d: float = 0.0

func _process(delta):
	if Input.is_key_pressed(KEY_D):
		hold_d += delta
		if hold_d >= 0.8:
			get_tree().change_scene_to_file("res://BarScene.tscn")
	else:
		hold_d = 0.0
