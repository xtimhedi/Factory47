extends Node

var SelectedItemID : String = "factory:stone"

func TransitionToScene(Scene: String):
	get_tree().change_scene_to_file(Scene);

func DisplayUI(UIScene):
	var Instance = UIScene.instantiate()
	Instance.visible=false
	add_child(Instance)
	return Instance
	
func SpawnByID(ItemID: String,pos):
	var idstring = ItemID.split(":")
	var base = idstring[0]
	var id = idstring[1]
	var path = "res://Blocks/{base}/{id}.tscn".format({"id": id,"base": base})
	var packed_scene = load(path)
	if packed_scene:
		var instance = packed_scene.instantiate()
		get_tree().root.add_child(instance)
		instance.global_position = pos
	else:
		print("[WARN] Could not find RegisteredBlock {id}".format({"id": ItemID}))

	
	
