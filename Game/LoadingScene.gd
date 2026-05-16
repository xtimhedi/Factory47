extends Node2D

const TARGET_SCENE_PATH = "res://Game/MainGameScene.tscn"

var actctr : int
var progress : Array = []

func _ready() -> void:
	var error = ResourceLoader.load_threaded_request(TARGET_SCENE_PATH)
	if error != OK:
		print("Error starting background load.")

func _process(delta: float) -> void:
	$counter.text = str(actctr)
	actctr += 1
	var status = ResourceLoader.load_threaded_get_status(TARGET_SCENE_PATH, progress)
	
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed_scene : PackedScene = ResourceLoader.load_threaded_get(TARGET_SCENE_PATH)
		var new_scene = packed_scene.instantiate()
		get_tree().root.add_child(new_scene)
		
		get_tree().current_scene = new_scene
		queue_free()
		
	elif status == ResourceLoader.THREAD_LOAD_FAILED or status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		print("Background loading failed.")
		set_process(false)
