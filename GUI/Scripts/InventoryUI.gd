extends Control

@onready var grid = %InventoryContainer
@export var Data: InventoryData = preload("res://Inventory/PlayerInventory.tres")
var Slot = preload("res://GUI/Scenes/ItemSlot.tscn")
var Number : int = 0


func Update(inventory: InventoryData):
	# clear existing visual slots
	for child in grid.get_children():
		child.queue_free()
		
	# create a new visual slot for every item in data
	for item in inventory.slots:
		var slot_instance = Slot.instantiate()
		grid.add_child(slot_instance)
		
		if item:
			# set item in slot and set item.id so it can be accessed by the ItemSlot.button
			slot_instance.SetItem(item)
			slot_instance.id = item.id
			slot_instance.isCreative = item.isCreative
			slot_instance.count = item.count
			slot_instance.SlotIndex = Number
			if item.isCreative:
				slot_instance.count = 1
				print(slot_instance.count)
			
		Number += 1

var CTR = 0
# update the display
func _ready() -> void:
	Update(Data)
	CTR += 2
	print(CTR)
	
	
func _process(float) -> void:
	if CTR > 1:
		for slot in Data.slots:
			if slot.count < 1:
				Data.slots.erase(slot)
				Update(Data)
		CTR += 1
