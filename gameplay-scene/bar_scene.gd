extends Node2D

var hold_w: float = 0.0
var hold_a: float = 0.0

func _process(delta):
	if Input.is_key_pressed(KEY_W):
		hold_w += delta
		if hold_w >= 0.8:
			get_tree().change_scene_to_file("res://gameplay-scene/game.tscn")
	else:
		hold_w = 0.0

	if Input.is_key_pressed(KEY_A):
		hold_a += delta
		if hold_a >= 0.8:
			get_tree().change_scene_to_file("res://AlleyScene.tscn")
	else:
		hold_a = 0.0
