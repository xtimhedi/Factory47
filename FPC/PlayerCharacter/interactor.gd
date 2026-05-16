extends RayCast3D

const BREAK_OVERLAY_SCENE = preload("res://CustomScenes/BreakOverlay3D.tscn")
@onready var play_char : CharacterBody3D = $"../../../.."
var IsDoingAction = false

var is_breaking: bool = false
var break_time_elapsed: float = 0.0
var break_duration: float = 0.8
var current_target_block: Object = null
var active_overlay: MeshInstance3D = null
var total_crack_stages: int = 4

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("break"):
		StopAction()
	if event.is_action_pressed("break"):
		StartAction()
		
		
func StartAction() -> void:
	if is_colliding():
		var collider = get_collider()
		if collider and collider.has_method("destroy"):
			is_breaking = true
			break_time_elapsed = 0.0
			current_target_block = collider
			active_overlay = BREAK_OVERLAY_SCENE.instantiate()
			current_target_block.add_child(active_overlay)
			active_overlay.global_position = current_target_block.global_position
	
func StopAction() -> void:
	if is_instance_valid(active_overlay):
		active_overlay.queue_free()
	is_breaking = false
	break_time_elapsed = 0.0
	current_target_block = null

func breakBlock() -> void:
	if is_instance_valid(current_target_block):
		current_target_block.destroy()


func _process(delta: float) -> void:
	if is_breaking:
		if is_colliding() and get_collider() == current_target_block:
			break_time_elapsed += delta
			var progress = clamp(break_time_elapsed / break_duration, 0.0, 1.0)
			var current_stage = min(int(progress * total_crack_stages), total_crack_stages - 1)
			if is_instance_valid(active_overlay):
				var mat = active_overlay.get_active_material(0) as ShaderMaterial
				if mat:
					mat.set_shader_parameter("frame_index", float(current_stage))
			if break_time_elapsed >= break_duration:
				breakBlock()
				StopAction()
		else:
			StopAction()

	if Input.is_action_just_pressed("place"):
		if is_colliding():
			if !get_collider().has_gui:
				var normal = get_collision_normal()
				var hit_point = get_collision_point()
				var spawn_pos = hit_point + (normal * 0.5) 
				spawn_pos = spawn_pos.snapped(Vector3.ONE)
				GlobalUI.SpawnByID(GlobalUI.SelectedItemID, spawn_pos)
			elif get_collider().has_gui:
				if str(play_char.state_machine.curr_state_name) == "Crouch":
					var normal = get_collision_normal()
					var hit_point = get_collision_point()
					var spawn_pos = hit_point + (normal * 0.5) 
					spawn_pos = spawn_pos.snapped(Vector3.ONE)
					GlobalUI.SpawnByID(GlobalUI.SelectedItemID, spawn_pos)
				else:
					if get_collider().has_method("OpenUI"):
						get_collider().OpenUI()
