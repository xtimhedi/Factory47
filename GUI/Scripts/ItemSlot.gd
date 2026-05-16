extends Control

@onready var icon_display = $Button/TextureRect
@export var id = ""
@export var count : int
@export var isCreative = false
@export var SlotIndex : int


func SetItem(item: ItemData):
	if item:
		# Show the icon
		icon_display.texture = item.icon
		icon_display.visible = true
	else:
		# Hide the icon if the slot is empty
		icon_display.visible = false

func ChangeSelectedBlock():
	GlobalUI.SelectedItemID = id
	
func _process(delta: float) -> void:
	if not isCreative:
		if count < 100:
			$Button/Label.text = str(count)
		else:
			$Button/Label.text = str(99)
	else:
		
		$Button/Label.text = "∞"
