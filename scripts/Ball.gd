extends RigidBody2D

func _integrate_forces( state ):
	if (state.get_contact_count() > 0):
		var collider = state.get_contact_collider_object(0)
		if collider.get_collision_layer_bit(1):
			var collision_pos = state.get_contact_local_position(0)
			var velocities = collider.deformer.get_velocities()
			var node_positions = collider.polygon.get_polygon()
			# Find closest polygon
			var min_dist = (collision_pos - collider.polygon.global_transform.xform((node_positions[0]))).length()
			var min_idx = -1
			var min_pos
			for i in range(0, node_positions.size()):
				var dist = (collision_pos - collider.polygon.global_transform.xform(node_positions[i])).length()
				if (dist < min_dist):
					min_dist = dist
					min_idx = i

			var idx1 = min_idx
			var idx2
			if (collision_pos - collider.polygon.global_transform.xform((node_positions[(min_idx - 1) % node_positions.size()]))).length() < (collision_pos - node_positions[(min_idx + 1) % node_positions.size()]).length():
				idx2 = min_idx - 1
			else:
				idx2 = (min_idx + 1) % node_positions.size()

			var seglen = (node_positions[idx1] - node_positions[idx2]).length()
			var dist1 = (collision_pos - collider.polygon.global_transform.xform(node_positions[idx1])).length()

			var a = dist1 / seglen

			var surface_velocity = collider.polygon.global_transform.basis_xform(velocities[idx1]) * (1.0 - a) + collider.polygon.global_transform.basis_xform(velocities[idx2]) * a

			var coll_normal = state.get_contact_local_normal(0)
			var coll_tang = coll_normal.rotated(0.5 * PI)

			var velocity_tang = linear_velocity.dot(coll_tang) * coll_tang
			var velocity_normal = linear_velocity.dot(coll_normal) * coll_normal
			var surf_velocity_normal = surface_velocity.dot(coll_normal) * coll_normal

			if surf_velocity_normal.length() > velocity_normal.length():
				velocity_normal = surf_velocity_normal

			set_linear_velocity(velocity_tang + velocity_normal)
