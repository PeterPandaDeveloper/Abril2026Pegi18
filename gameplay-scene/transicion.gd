extends CanvasLayer

@onready var fondo = $ColorRect
var en_progreso = false

func _ready():
	layer = 100 
	fondo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fondo.color = Color.BLACK 
	fondo.hide()

# Mantenemos la palabra "mensaje" en el código para no tener que 
# ir a borrarla en todos tus otros scripts, pero simplemente la ignoramos.
func cambiar_escena(ruta: String, mensaje: String = ""):
	if en_progreso: 
		return
	en_progreso = true
	
	# 1. PANTALLA NEGRA INSTANTÁNEA
	fondo.show()
	
	# 2. ESPERAMOS SOLO MEDIO SEGUNDO (Ya no hay texto que leer)
	await get_tree().create_timer(0.5).timeout
	
	# 3. CAMBIO DE ESCENA
	get_tree().change_scene_to_file(ruta)
	
	# 4. MICRO-PAUSA DE CARGA
	await get_tree().create_timer(0.2).timeout
	
	# 5. APAGAR PANTALLA NEGRA
	fondo.hide()
	
	en_progreso = false
