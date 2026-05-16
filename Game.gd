extends Node

@export var CWidth : int
@export var CLength : int
@export var Type : String

func GenerateTerrainedWorld(ChunkX:int=1,ChunkZ:int=1):
	CWidth = ChunkX
	CLength = ChunkZ
	Type = "factory:gen_classic" 
	get_tree().change_scene_to_file("res://Game/LoadingScene.tscn");
			
func GenerateFlatmap(ChunkX:int=1,ChunkZ:int=1):
	CWidth = ChunkX
	CLength = ChunkZ
	Type = "factory:gen_flat" 
	get_tree().change_scene_to_file("res://Game/LoadingScene.tscn");
	
