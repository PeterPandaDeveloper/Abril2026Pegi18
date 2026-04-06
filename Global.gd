extends Node

var dinero: int = 100
var escena_previa: String = ""

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_TAB: # En Godot 4 es keycode en vez de scancode
			alternar_registro()

func alternar_registro():
	if get_tree().current_scene.name != "RegistryScene":
		escena_previa = get_tree().current_scene.scene_file_path # En Godot 4 es scene_file_path
		get_tree().change_scene_to_file("res://RegistryScene.tscn")
	else:
		if escena_previa != "":
			get_tree().change_scene_to_file(escena_previa)
