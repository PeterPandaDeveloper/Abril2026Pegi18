extends Node2D

var hold_w: float = 0.0
var hold_a: float = 0.0
var tiempo_viaje: float = 0.8

func _process(delta):
	var moviendo = false
	
	# IR AL BLACKJACK (W)
	if Input.is_key_pressed(KEY_W):
		hold_w += delta
		moviendo = true
		if hold_w >= tiempo_viaje:
			hold_w = 0.0 # ¡CRUCIAL! Reiniciamos el contador antes de viajar
			Transicion.cambiar_escena("res://gameplay-scene/game.tscn", "Yendo a la mesa...")
	else:
		hold_w = 0.0

	# IR AL CALLEJÓN (A)
	if Input.is_key_pressed(KEY_A):
		hold_a += delta
		moviendo = true
		if hold_a >= tiempo_viaje:
			hold_a = 0.0 # ¡CRUCIAL! Reiniciamos el contador antes de viajar
			Transicion.cambiar_escena("res://gameplay-scene/AlleyScene.tscn", "Saliendo al callejón oscuro...")
	else:
		hold_a = 0.0
		
	# CONTROL MÁGICO DE LA BARRA
	if has_node("BarraViaje"):
		$BarraViaje.visible = moviendo
		if hold_w > 0:
			$BarraViaje.value = (hold_w / tiempo_viaje) * 100
		elif hold_a > 0:
			$BarraViaje.value = (hold_a / tiempo_viaje) * 100
		else:
			$BarraViaje.value = 0
