extends Node2D

var hold_d: float = 0.0

# NUESTRA MEGA BASE DE DATOS POLIMÓRFICA
var base_datos = {
	"Secretos": [
		{"id": 100, "nombre": "Carpeta Top Secret", "ruta": "res://assets/images/items/secreto.png"}
	],
	"Bases": [
		{"id": 1, "nombre": "Ron Blanco de Wesnal", "ruta": "res://assets/images/items/base.png"},
		{"id": 2, "nombre": "Jägermeister Espectral", "ruta": "res://assets/images/items/base.png"},
		{"id": 3, "nombre": "Whiskey Clásico de Northp", "ruta": "res://assets/images/items/base.png"},
		{"id": 4, "nombre": "Vino de Ciraxia", "ruta": "res://assets/images/items/base.png"},
		{"id": 5, "nombre": "Ginebra de Contrabando", "ruta": "res://assets/images/items/base.png"},
		{"id": 6, "nombre": "Agua con cola bailable", "ruta": "res://assets/images/items/base.png"},
		{"id": 7, "nombre": "Licor Dracónico Real", "ruta": "res://assets/images/items/base.png"},
		{"id": 8, "nombre": "Vodka Glacial de Fresquiñon", "ruta": "res://assets/images/items/base.png"},
		{"id": 9, "nombre": "Aguamiel de Bullrath", "ruta": "res://assets/images/items/base.png"},
		{"id": 10, "nombre": "Destilado Pirata", "ruta": "res://assets/images/items/base.png"},
		{"id": 11, "nombre": "Licor Fermentado de Gaum", "ruta": "res://assets/images/items/base.png"}
	],
	"Mezcladores": [
		{"id": 12, "nombre": "Zumo de Limón", "ruta": "res://assets/images/items/mezcla.png"},
		{"id": 13, "nombre": "Vial de Agua Pura", "ruta": "res://assets/images/items/mezcla.png"},
		{"id": 14, "nombre": "Lágrimas de Lemuria", "ruta": "res://assets/images/items/mezcla.png"},
		{"id": 15, "nombre": "Néctar de Deeswalya", "ruta": "res://assets/images/items/mezcla.png"},
		{"id": 16, "nombre": "Caldo Especiado de Eldoon", "ruta": "res://assets/images/items/mezcla.png"},
		{"id": 17, "nombre": "Tónica de Glatux", "ruta": "res://assets/images/items/mezcla.png"},
		{"id": 18, "nombre": "Jarabe de Carnavelle", "ruta": "res://assets/images/items/mezcla.png"},
		{"id": 19, "nombre": "Esencia de Crisol", "ruta": "res://assets/images/items/mezcla.png"},
		{"id": 20, "nombre": "Jugo de Mango", "ruta": "res://assets/images/items/mezcla.png"},
		{"id": 21, "nombre": "Extracto de Kiwi", "ruta": "res://assets/images/items/mezcla.png"},
		{"id": 22, "nombre": "Tinta Vegetal de mar de la mancha", "ruta": "res://assets/images/items/mezcla.png"}
	],
	"Modificadores": [
		{"id": 23, "nombre": "Hielo Estándar", "ruta": "res://assets/images/items/img_ice.webp"},
		{"id": 24, "nombre": "Hielo de vapor", "ruta": "res://assets/images/items/img_ice.webp"},
		{"id": 25, "nombre": "Piedra Ígnea", "ruta": "res://assets/images/items/img_ice.webp"},
		{"id": 26, "nombre": "Prisma bajo cero", "ruta": "res://assets/images/items/img_ice.webp"},
		{"id": 27, "nombre": "Ingnitio diminuto", "ruta": "res://assets/images/items/img_ice.webp"},
		{"id": 28, "nombre": "Cuarzo de Brior", "ruta": "res://assets/images/items/img_ice.webp"},
		{"id": 29, "nombre": "Rodaja de Cítrico Seco", "ruta": "res://assets/images/items/img_ice.webp"},
		{"id": 30, "nombre": "Cristal de caramelo", "ruta": "res://assets/images/items/img_ice.webp"},
		{"id": 31, "nombre": "Mármol de Norio", "ruta": "res://assets/images/items/img_ice.webp"},
		{"id": 32, "nombre": "Perla de Aher", "ruta": "res://assets/images/items/img_ice.webp"},
		{"id": 33, "nombre": "Roca de Sal", "ruta": "res://assets/images/items/img_ice.webp"}
	],
	"Toque Final": [
		{"id": 34, "nombre": "Hoja de Menta", "ruta": "res://assets/images/items/hoja.png"},
		{"id": 35, "nombre": "Hoja Naranja de Biqal", "ruta": "res://assets/images/items/hoja.png"},
		{"id": 36, "nombre": "Dupli Arandano", "ruta": "res://assets/images/items/hoja.png"},
		{"id": 37, "nombre": "Frambuesa Sangrienta", "ruta": "res://assets/images/items/hoja.png"},
		{"id": 38, "nombre": "Cereza Gigante", "ruta": "res://assets/images/items/hoja.png"},
		{"id": 39, "nombre": "Hoja de Loto de Hanabusa", "ruta": "res://assets/images/items/hoja.png"},
		{"id": 40, "nombre": "Hoja Maple de FuegoSol", "ruta": "res://assets/images/items/hoja.png"},
		{"id": 41, "nombre": "Baya de Lirio Brillante", "ruta": "res://assets/images/items/hoja.png"},
		{"id": 42, "nombre": "Fruto de baya ignea", "ruta": "res://assets/images/items/hoja.png"},
		{"id": 43, "nombre": "Hoja Dorada Dracónica", "ruta": "res://assets/images/items/hoja.png"},
		{"id": 44, "nombre": "Flor de Flux", "ruta": "res://assets/images/items/hoja.png"}
	]
}

func _ready():
	randomize() # Asegura que el azar sea diferente en cada partida
	generar_tienda()

func generar_tienda():
	var objetos_a_vender = []
	
	# 1. SIEMPRE habrá un Secreto a la venta
	var secreto_elegido = base_datos["Secretos"].pick_random().duplicate()
	secreto_elegido["categoria_real"] = "Secretos"
	objetos_a_vender.append(secreto_elegido)
	
	# 2. Elegimos al azar qué otras categorías tendrán stock (puede ser de 0 a 4 categorías)
	var categorias_extra = ["Bases", "Mezcladores", "Modificadores", "Toque Final"]
	categorias_extra.shuffle()
	
	# randi_range(0, 4) significa que a veces no habrá nada más, y a veces estará el maletín lleno
	var cantidad_categorias_activas = randi_range(0, categorias_extra.size()) 
	
	for i in range(cantidad_categorias_activas):
		var cat = categorias_extra[i]
		# De la categoría activa, agarramos UN SOLO objeto al azar
		var item_elegido = base_datos[cat].pick_random().duplicate()
		item_elegido["categoria_real"] = cat
		objetos_a_vender.append(item_elegido)
		
	# 3. Recogemos los 15 Marker2D (Pos1 a Pos15)
	var posiciones = []
	for i in range(1, 16):
		var nodo_pos = get_node_or_null("Pos" + str(i))
		if nodo_pos:
			posiciones.append(nodo_pos)
			
	# Desordenamos las posiciones para que los objetos caigan en cualquier casilla
	posiciones.shuffle()
	
	# 4. Dibujamos los objetos en la pantalla
	for i in range(objetos_a_vender.size()):
		var obj = objetos_a_vender[i]
		var marcador = posiciones[i]
		
		var imagen = TextureRect.new()
		
		# SISTEMA ANTI-CRASHEO: Si aún no has creado la imagen, Godot usará su logo por defecto
		if ResourceLoader.exists(obj["ruta"]):
			imagen.texture = ResourceLoader.load(obj["ruta"])
		else:
			imagen.texture = load("res://icon.svg")
			
		imagen.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		imagen.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		imagen.custom_minimum_size = Vector2(40, 40) # Tamaño fijo sin importar los píxeles reales
		
		# El texto flotante mostrará el Nombre y debajo su Categoría
		imagen.tooltip_text = obj["nombre"] + "\n[" + obj["categoria_real"] + "]"
		imagen.position = marcador.position - (imagen.custom_minimum_size / 2)
		
		add_child(imagen)

func _process(delta):
	# Si tienes la BarraViaje, su lógica va aquí
	if Input.is_key_pressed(KEY_D):
		hold_d += delta
		if hold_d >= 0.8:
			get_tree().change_scene_to_file("res://gameplay-scene/BarScene.tscn")
	else:
		hold_d = 0.0
