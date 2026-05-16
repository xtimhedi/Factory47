extends Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $%WorldgenPanel/WorldSetting.text == "Flatmap":
		$WorldgenPanel/FlatmapPanel.visible = true
		$WorldgenPanel/TerrainedPanel.visible = false
		$WorldgenPanel/CustomFlatmapPanel.visible = false
		
	elif $%WorldgenPanel/WorldSetting.text == "Terrained":
		$WorldgenPanel/FlatmapPanel.visible = false
		$WorldgenPanel/TerrainedPanel.visible = true
		$WorldgenPanel/CustomFlatmapPanel.visible = false
		
	elif $%WorldgenPanel/WorldSetting.text == "Flat (custom)":
		$WorldgenPanel/FlatmapPanel.visible = false
		$WorldgenPanel/TerrainedPanel.visible = false
		$WorldgenPanel/CustomFlatmapPanel.visible = true
		

func OnStartPressed():
	%MainPanel.visible = false
	$WorldgenPanel.visible = true
	#print("If you are here looking for errors, the game is NOT frozen. It is just simply generating terrain. This may take a while depending on your systems specs or available resources")
	#await GlobalUI.TransitionToScene("res://Game/LoadingScene.tscn")

func HandleExit():
	get_tree().quit()
	
func OnSettingsPressed():
	GlobalUI.TransitionToScene("res://GUI/Scenes/Settings.tscn")
	
func OnAboutButtonPressed():
	%MainPanel.visible = false
	$AboutPanel.visible = true
	
func OnAboutBackButtonPressed():
	%MainPanel.visible = true
	%AboutPanel.visible = false
	
func OnGenBackButtonPressed():
	%MainPanel.visible = true
	%WorldgenPanel.visible = false
	
func OnGenerateButtonPressed():
	var Selected = $WorldgenPanel/WorldSetting.text
	
	if Selected == "Flatmap":
		if $WorldgenPanel/FlatmapPanel/ChunkWidth.text != "":
			if $WorldgenPanel/FlatmapPanel/ChunkHeight.text != "":
				Game.GenerateFlatmap(int($WorldgenPanel/FlatmapPanel/ChunkWidth.text),int($WorldgenPanel/FlatmapPanel/ChunkHeight.text))
	elif Selected == "Terrained":
		if $WorldgenPanel/TerrainedPanel/ChunkWidth.text != "":
			if $WorldgenPanel/TerrainedPanel/ChunkHeight.text != "":
				Game.GenerateTerrainedWorld(int($WorldgenPanel/TerrainedPanel/ChunkWidth.text),int($WorldgenPanel/TerrainedPanel/ChunkHeight.text))
