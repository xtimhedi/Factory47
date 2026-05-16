extends Resource
class_name InventoryData

@export var slots: Array[ItemData] = []

func AddItem(item: ItemData):
	var ItemInstance = item.duplicate(true)
	slots.append(ItemInstance)
	
func SetCount(count:int,slot:int):
	slots[slot].count = count
	
func SetCreative(state,slot):
	slots[slot].isCreative = state
	
func FindItemsByID(id:String):
	var returner : Array
	var num : int
	for i in slots:
		if i.id == id:
			returner.append(i.SlotIndex)
			
	return returner
	
func DumpEmptyStacks():
	for i in slots:
		if i.count < 1:
			slots.erase(i)
	

		
