extends Node

@onready var InventoryUI = GlobalUI.DisplayUI(preload("res://GUI/Scenes/InventoryUI.tscn"))
@onready var playercam = $PlayerCharacter/CameraHolder
# Called when the node enters the scene tree for the first time.
signal FinishedGeneration
	
func generate():
	for x in range(0,Game.CWidth):
		for z in range(0,Game.CLength):
			if Game.Type == "factory:gen_flat":
				Worldgen.GenerateToplayer_Flat(x,z)
			if Game.Type == "factory:gen_classic":
				Worldgen.GenerateToplayer_Noise(x,z)
	for x in range(0,Game.CWidth):
		for z in range(0,Game.CLength):
			if Game.Type == "factory:gen_flat":
				Worldgen.GenerateMidlayer_Flat(x,z)
			if Game.Type == "factory:gen_classic":
				Worldgen.GenerateMidlayer_Noise(x,z)
	for x in range(0,Game.CWidth):
		for z in range(0,Game.CLength):
			if Game.Type == "factory:gen_flat":
				Worldgen.GenerateLowerlayer_Flat(x,z)
			if Game.Type == "factory:gen_classic":
				Worldgen.GenerateLowerlayer_Noise(x,z)
			

func _ready() -> void:
	
	InventoryUI.visible = false
	var thread = Thread.new()
	generate()

	# add the items
	InventoryUI.Data.AddItem(load("res://Inventory/Item/factory/Dirt.tres"))
	InventoryUI.Data.AddItem(load("res://Inventory/Item/factory/Stone.tres"))
	InventoryUI.Data.AddItem(load("res://Inventory/Item/factory/GrassBlock.tres"))
	InventoryUI.Data.AddItem(load("res://Inventory/Item/factory/Dirt.tres"))
	InventoryUI.Data.SetCreative(true,0)
	InventoryUI.Update(InventoryUI.Data)
	
	InventoryUI.Update(InventoryUI.Data)
	
	
	#∞
			
	FinishedGeneration.emit()	
	playercam.locked = false
	
	

func LockView(should_lock: bool):
	playercam.locked = should_lock
	if should_lock:
		playercam.mouse_free = true
	else:
		playercam.mouse_free = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $PlayerCharacter.position.y < -80:
		KillPlayer()
	if Input.is_action_just_pressed("inventory"):
		InventoryUI.visible = not InventoryUI.visible
		LockView(not playercam.locked)
		
func KillPlayer():
	print("killed player")
	$PlayerCharacter.position = Vector3(0,10,0)
		
		
