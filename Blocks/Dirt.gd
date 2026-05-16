extends StaticBody3D
@onready var mesh_instance = %MeshInstance3D
var total_crack_stages = 4
# this needs to be set in EVERY BLOCK, or shit breaks. idk dont ask me
var has_gui = false
func _ready():
	# Force the body to update its shape after entering the tree
	if has_node("StaticBody3D"):
		var sb = get_node("StaticBody3D")
		sb.set_deferred("monitoring", true)
		sb.set_deferred("monitorable", true)
func destroy():
	queue_free()

# this is unused in GrassBlock as there is NO GUI
func OpenUI():
	pass
