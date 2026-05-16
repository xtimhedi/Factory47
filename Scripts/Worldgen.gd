extends Node

var Noisemap = FastNoiseLite.new()

var IronChance : int = 10

func GenerateToplayer_Flat(X:int,Z:int):
	var Level = get_tree().current_scene
	var char = Level.find_child("PlayerCharacter")
	var a = X*4
	var b = Z*4
	for x in range(-2,2):
		for z in range(-2,2):
			for y in range(0,1):
				GlobalUI.SpawnByID("factory:grass_block", Vector3(x+a,y,z+b))
func GenerateMidlayer_Flat(X:int,Z:int):
	var Level = get_tree().current_scene
	var char = Level.find_child("PlayerCharacter")
	var a = X*4
	var b = Z*4
	for x in range(-2,2):
		for z in range(-2,2):
			for y in range(-3,-0):
				GlobalUI.SpawnByID("factory:dirt", Vector3(x+a,y,z+b))
func GenerateLowerlayer_Flat(X:int,Z:int):
	var GenOre : bool
	var Level = get_tree().current_scene
	var char = Level.find_child("PlayerCharacter")
	var a = X*4
	var b = Z*4
	for x in range(-2,2):
		for z in range(-2,2):
			for y in range(-10,-3):
				if randi() % 10 == randi() % 10:
					GenOre = true
				else:
					GenOre = false
					
				if GenOre:
					# iron
					if randi() % IronChance == randi() % IronChance:
						GlobalUI.SpawnByID("factory:iron_ore", Vector3(x+a,y,z+b))
					else:
						GlobalUI.SpawnByID("factory:stone", Vector3(x+a,y,z+b))
				else:
					GlobalUI.SpawnByID("factory:stone", Vector3(x+a,y,z+b))
		
		
				
func GenerateToplayer_Noise(X: int, Z: int):
	var a = X * 4
	var b = Z * 4
	
	var base_y = -10
	var height_range = 20
	
	for x in range(-2, 2):
		var world_x = x + a
		
		for z in range(-2, 2):
			var world_z = z + b
			var noise_val = Noisemap.get_noise_2d(float(world_x), float(world_z))
			var surface_y = base_y + int((noise_val + 1.0) * 0.5 * height_range)
			for y in range(-32, surface_y + 1):
				var world_pos = Vector3(world_x, y, world_z)
				
				if y == surface_y:
					GlobalUI.SpawnByID("factory:grass_block", world_pos)
				elif y > surface_y - 3:
					pass
				else:
					pass
func GenerateMidlayer_Noise(X: int, Z: int):
	var a = X * 4
	var b = Z * 4
	
	var base_y = -10
	var height_range = 20
	
	for x in range(-2, 2):
		var world_x = x + a
		
		for z in range(-2, 2):
			var world_z = z + b
			var noise_val = Noisemap.get_noise_2d(float(world_x), float(world_z))
			var surface_y = base_y + int((noise_val + 1.0) * 0.5 * height_range)
			for y in range(-32, surface_y + 1):
				var world_pos = Vector3(world_x, y, world_z)
				
				if y == surface_y:
					pass
				elif y > surface_y - 3:
					GlobalUI.SpawnByID("factory:dirt", world_pos)
				else:
					pass
func GenerateLowerlayer_Noise(X: int, Z: int):
	var a = X * 4
	var b = Z * 4
	
	var base_y = -10
	var height_range = 20
	
	for x in range(-2, 2):
		var world_x = x + a
		
		for z in range(-2, 2):
			var world_z = z + b
			var noise_val = Noisemap.get_noise_2d(float(world_x), float(world_z))
			var surface_y = base_y + int((noise_val + 1.0) * 0.5 * height_range)
			for y in range(-32, surface_y + 1):
				var world_pos = Vector3(world_x, y, world_z)
				
				if y == surface_y:
					pass
				elif y > surface_y - 3:
					pass
				elif y > surface_y - 10:
					GlobalUI.SpawnByID("factory:stone", world_pos)
					
				
					
