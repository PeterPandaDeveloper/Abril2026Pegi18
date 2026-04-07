extends Node2D

var hold_w: float = 0.0
var hold_a: float = 0.0
var tiempo_viaje: float = 0.8 # Tiempo que tarda en llenarse la barra

func _process(delta):
	var moviendo = false
	
	# Asegurarnos de que la barra exista y esté oculta por defecto
	if has_node("BarraViaje"):
		$BarraViaje.visible = hold_w > 0 or hold_a > 0

	# IR AL BLACKJACK (W)
	if Input.is_key_pressed(KEY_W):
		hold_w += delta
		moviendo = true
		if has_node("BarraViaje"):
			$BarraViaje.value = (hold_w / tiempo_viaje) * 100
		
		if hold_w >= tiempo_viaje:
			get_tree().change_scene_to_file("res://gameplay-scene/game.tscn")
	else:
		hold_w = 0.0

	# IR AL CALLEJÓN (A)
	if Input.is_key_pressed(KEY_A):
		hold_a += delta
		moviendo = true
		if has_node("BarraViaje"):
			$BarraViaje.value = (hold_a / tiempo_viaje) * 100
		
		if hold_a >= tiempo_viaje:
			get_tree().change_scene_to_file("res://gameplay-scene/AlleyScene.tscn")
	else:
		hold_a = 0.0
		
	# Reiniciar barra si soltamos teclas
	if not moviendo and has_node("BarraViaje"):
		$BarraViaje.value = 0
