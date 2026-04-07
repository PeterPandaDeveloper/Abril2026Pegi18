extends Node2D

var hold_w: float = 0.0
var hold_a: float = 0.0
var tiempo_viaje: float = 0.8

func _process(delta):
	# --- ESCUDO ANTI-REPETICIÓN ---
	# Si ya estamos viajando, la barra se queda en 100 y no leemos más teclas
	if Transicion.en_progreso:
		if has_node("BarraViaje"):
			$BarraViaje.value = 100
		return # Cortamos la ejecución aquí mismo
		
	var moviendo = false
	
	# IR AL BLACKJACK (W)
	if Input.is_key_pressed(KEY_W):
		hold_w += delta
		moviendo = true
		if hold_w >= tiempo_viaje:
			hold_w = 0.0 
			Transicion.cambiar_escena("res://gameplay-scene/game.tscn", "Yendo a la mesa...")
	else:
		hold_w = 0.0

	# IR AL CALLEJÓN (A)
	if Input.is_key_pressed(KEY_A):
		hold_a += delta
		moviendo = true
		if hold_a >= tiempo_viaje:
			hold_a = 0.0 
			Transicion.cambiar_escena("res://gameplay-scene/AlleyScene.tscn", "Saliendo al callejón oscuro...")
	else:
		hold_a = 0.0
		
	# CONTROL DE LA BARRA
	if has_node("BarraViaje"):
		$BarraViaje.visible = moviendo
		if hold_w > 0:
			$BarraViaje.value = (hold_w / tiempo_viaje) * 100
		elif hold_a > 0:
			$BarraViaje.value = (hold_a / tiempo_viaje) * 100
		else:
			$BarraViaje.value = 0
