extends CanvasLayer

@onready var fondo = $ColorRect
@onready var texto = $Label
var en_progreso = false

func _ready():
	fondo.mouse_filter = Control.MOUSE_FILTER_IGNORE

func cambiar_escena(ruta: String, mensaje: String):
	if en_progreso: 
		return
		
	en_progreso = true
	texto.text = mensaje
	
	# FADE IN (Oscurecer)
	var tween_in = create_tween().set_parallel(true)
	tween_in.tween_property(fondo, "modulate:a", 1.0, 0.5)
	tween_in.tween_property(texto, "modulate:a", 1.0, 0.5)
	await tween_in.finished
	
	# CAMBIO DE ESCENA
	get_tree().change_scene_to_file(ruta)
	await get_tree().create_timer(0.2).timeout
	
	# FADE OUT (Aclarar)
	var tween_out = create_tween().set_parallel(true)
	tween_out.tween_property(fondo, "modulate:a", 0.0, 0.5)
	tween_out.tween_property(texto, "modulate:a", 0.0, 0.5)
	await tween_out.finished
	
	en_progreso = false
