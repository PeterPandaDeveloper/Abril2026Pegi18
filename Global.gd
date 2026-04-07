extends Node

var dinero: int = 100
var escena_previa: String = ""
var auto_guardado: bool = true # El jugador podrá apagar esto después

# Diccionario para empaquetar todos los datos fácilmente
var datos_guardado = {
	"dinero": 100,
	"auto_guardado": true
}

func _ready():
	cargar_partida() # Carga la partida apenas arranca el juego

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_TAB:
			alternar_registro()

func alternar_registro():
	if get_tree().current_scene.name != "RegistryScene":
		escena_previa = get_tree().current_scene.scene_file_path
		get_tree().change_scene_to_file("res://gameplay-scene/RegistryScene.tscn")
	else:
		if escena_previa != "":
			get_tree().change_scene_to_file(escena_previa)

# --- SISTEMA DE GUARDADO ---
func guardar_partida():
	datos_guardado["dinero"] = dinero
	datos_guardado["auto_guardado"] = auto_guardado
	
	# Crea un archivo en la carpeta secreta de Godot en tu Linux
	var file = FileAccess.open("user://casino_mafia.save", FileAccess.WRITE)
	if file:
		file.store_var(datos_guardado)
		file.close()
		print("💾 ¡Partida Guardada! Dinero actual: ", dinero)

func cargar_partida():
	if FileAccess.file_exists("user://casino_mafia.save"):
		var file = FileAccess.open("user://casino_mafia.save", FileAccess.READ)
		if file:
			datos_guardado = file.get_var()
			dinero = datos_guardado.get("dinero", 100)
			auto_guardado = datos_guardado.get("auto_guardado", true)
			file.close()
			print("📂 Partida Cargada. Dinero recuperado: ", dinero)
