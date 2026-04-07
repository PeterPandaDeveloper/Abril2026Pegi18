extends CanvasLayer

func _ready():
	# Hacemos que el menú sea invisible apenas arranca el juego
	visible = false

func _input(event):
	# Si presionas la tecla ESC
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			# Si estaba invisible, se hace visible. Si estaba visible, se oculta.
			visible = not visible

# --- ESTAS SON LAS FUNCIONES OFICIALES QUE GODOT CREÓ ---

func _on_btn_guardar_pressed() -> void:
	Global.guardar_partida()
	# Ocultar el menú después de guardar
	visible = false

func _on_btn_salir_pressed() -> void:
	# Esto cierra el juego de inmediato
	get_tree().quit()
