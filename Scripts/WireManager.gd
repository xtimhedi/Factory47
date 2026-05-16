extends Node

## Spawns a physical 3D cable between two coordinates using an unbroken volumetric tube.
## [param pos_1]: The starting global position.
## [param pos_2]: The ending global position.
## [param thickness]: The visual radius of the cable cylinder mesh.
## [param segments]: Total physics links. Higher values mean smoother curves.
## [param tightness]: Cable tension. Lower values (0.2) drop heavily. Higher values (1.5+) pull it taut.
func SpawnCable(pos_1: Vector3, pos_2: Vector3, thickness: float = 0.2, segments: int = 15, tightness: float = 1) -> Node3D:
	# Root parent container node
	print("Cable entere tree")
	var cable_root := Node3D.new()
	get_tree().current_scene.add_child(cable_root)
	
	var straight_dist := pos_1.distance_to(pos_2)
	var segment_length := straight_dist / segments
	var direction := (pos_2 - pos_1).normalized()
	
	# Start static rigid anchor
	var anchor_a := StaticBody3D.new()
	anchor_a.global_position = pos_1
	cable_root.add_child(anchor_a)
	
	# Visual Mesh Engine Configuration
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()
	
	material.albedo_color = Color("1e2122") # Industrial matte black finish
	material.roughness = 0.5
	mesh_instance.mesh = immediate_mesh
	mesh_instance.material_override = material
	cable_root.add_child(mesh_instance)
	
	var previous_body: PhysicsBody3D = anchor_a
	var rigid_segments: Array[RigidBody3D] = []
	
	# Create Physics Segment Chain Loops
	for i in range(segments):
		var t := float(i + 1) / float(segments)
		var target_pos := pos_1.lerp(pos_2, t)
		
		# Inverse-proportion sag configuration calculation based on tightness value
		# Lower tightness = deep curve shape drop profile
		var sag_multiplier := 0.0 if tightness >= 1.0 else (1.0 - tightness)
		var sag_factor := sin(t * PI) * (straight_dist * 0.4 * sag_multiplier)
		var spawn_pos := target_pos + (Vector3.DOWN * sag_factor)
		
		var segment := RigidBody3D.new()
		segment.global_position = spawn_pos
		segment.linear_damp = 0.5
		segment.angular_damp = 2.0
		
		# High tightness values reduce physics gravity weight influence to keep structural tension straight
		if tightness > 1.0:
			segment.gravity_scale = clamp(2.0 - tightness, 0.0, 1.0)
		else:
			segment.gravity_scale = 1.0
			
		# Collision hull properties
		var collision_shape := CollisionShape3D.new()
		var capsule := CapsuleShape3D.new()
		capsule.radius = thickness
		capsule.height = segment_length
		collision_shape.shape = capsule
		
		if direction != Vector3.UP and direction != Vector3.DOWN:
			collision_shape.look_at_from_position(Vector3.ZERO, direction, Vector3.UP)
			collision_shape.rotate_object_local(Vector3.RIGHT, deg_to_rad(90))
			
		segment.add_child(collision_shape)
		cable_root.add_child(segment)
		rigid_segments.append(segment)
		
		# Joint configurations
		var joint := Generic6DOFJoint3D.new()
		cable_root.add_child(joint)
		joint.global_position = pos_1.lerp(pos_2, float(i)/segments) + (Vector3.DOWN * sag_factor)
		
		joint.node_a = previous_body.get_path()
		joint.node_b = segment.get_path()
		
		# Set angular constraints dynamically to control rigidity stiffness behavior
		# High tightness limits angular rotation sway freedom limits
		var flex_angle: float = clamp(45.0 * tightness, 5.0, 90.0)

		joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_UPPER_LIMIT, deg_to_rad(flex_angle))
		joint.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_LOWER_LIMIT, deg_to_rad(-flex_angle))
		joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_UPPER_LIMIT, deg_to_rad(flex_angle))
		joint.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_LOWER_LIMIT, deg_to_rad(-flex_angle))
		
		# Apply internal spring force parameters to simulate linear pull stiffness tension when taut
		if tightness > 1.0:
			joint.set_flag_x(Generic6DOFJoint3D.FLAG_ENABLE_LINEAR_SPRING, true)
			joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_STIFFNESS, (tightness - 1.0) * 50.0)
			joint.set_param_x(Generic6DOFJoint3D.PARAM_LINEAR_SPRING_EQUILIBRIUM_POINT, 0.0)
			
		previous_body = segment
		
	# Terminating end point anchor structures
	var anchor_b := StaticBody3D.new()
	anchor_b.global_position = pos_2
	cable_root.add_child(anchor_b)
	
	var final_joint := Generic6DOFJoint3D.new()
	cable_root.add_child(final_joint)
	final_joint.global_position = pos_2
	final_joint.node_a = previous_body.get_path()
	final_joint.node_b = anchor_b.get_path()
	
	# Instantiate our dynamic cylinder processor runtime worker
	var updater := CableUpdater.new()
	updater.setup(immediate_mesh, pos_1, pos_2, rigid_segments, thickness, material)
	cable_root.add_child(updater)
	
	return cable_root

# Dynamic continuous tube builder 
class CableUpdater extends Node3D:
	var mesh: ImmediateMesh
	var p1: Vector3
	var p2: Vector3
	var segments: Array[RigidBody3D]
	var radius: float
	var radial_resolution: int = 6 
	var material: StandardMaterial3D
	
	func setup(_mesh: ImmediateMesh, _p1: Vector3, _p2: Vector3, _segments: Array[RigidBody3D], _rad: float, _mat: StandardMaterial3D):
		mesh = _mesh
		p1 = _p1
		p2 = _p2
		segments = _segments
		radius = _rad
		material = _mat
		
	func _process(_delta: float) -> void:
		
		mesh.clear_surfaces()
		mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
		
		var points: Array[Vector3] = [p1]
		for seg in segments:
			points.append(seg.global_position)
		points.append(p2)
		
		var num_points := points.size()
		if num_points < 2:
			return
			
		var rings: Array = []
		
		for i in range(num_points):
			var curr_center := points[i] - global_position
			var dir := Vector3.ZERO
			if i == 0:
				dir = (points[1] - points[0]).normalized()
			elif i == num_points - 1:
				dir = (points[num_points - 1] - points[num_points - 2]).normalized()
			else:
				var dir_in := (points[i] - points[i-1]).normalized()
				var dir_out := (points[i+1] - points[i]).normalized()
				dir = (dir_in + dir_out).normalized()
				
			if dir.is_zero_approx():
				dir = Vector3.FORWARD
				
			var up_vec := Vector3.UP if abs(dir.dot(Vector3.UP)) < 0.99 else Vector3.FORWARD
			var right_vec := dir.cross(up_vec).normalized()
			var up_orthogonal := right_vec.cross(dir).normalized()
			
			var ring_points: Array[Vector3] = []
			for j in range(radial_resolution + 1):
				var angle := (float(j) / radial_resolution) * TAU
				var offset := (right_vec * cos(angle) + up_orthogonal * sin(angle)) * radius
				ring_points.append(curr_center + offset)
				
			rings.append(ring_points)
			
		for i in range(num_points - 1):
			var curr_ring: Array = rings[i]
			var next_ring: Array = rings[i+1]
			
			for j in range(radial_resolution):
				mesh.surface_add_vertex(curr_ring[j])
				mesh.surface_add_vertex(next_ring[j])
				mesh.surface_add_vertex(next_ring[j+1])
				
				mesh.surface_add_vertex(curr_ring[j])
				mesh.surface_add_vertex(next_ring[j+1])
				mesh.surface_add_vertex(curr_ring[j+1])
				
		mesh.surface_end()
		material.albedo_color = Color("721018ff")
		material.albedo_color = Color("170101ff")
