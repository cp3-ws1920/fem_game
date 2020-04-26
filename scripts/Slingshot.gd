extends StaticBody2D

enum STATE {
	grabbed,
	free
}

var state

var grabbed_node
var nodes

onready var polygon = get_node("Polygon2D")
onready var deformer = get_node("Polygon2D/ElasticBody2D")
onready var polygon_display = get_node("PolygonDisplay")
onready var line = get_node("Line2D")

export var grab_radius = 5.0
export var grab_force = 250.0
export var max_force = 10000.0

func _ready():
	nodes = polygon.get_polygon()
	state = STATE.free

func _enter_state(new_state):
	state = new_state

func _process(delta):
	match state:
		STATE.free:
			if Input.is_action_just_pressed("drag"):
				grabbed_node = get_grabbed_node()
				if grabbed_node > -1:
					_enter_state(STATE.grabbed)
		STATE.grabbed:
			if Input.is_action_just_released("drag"):
				deformer.forces[grabbed_node] = Vector2(0.0, 0.0)
				_enter_state(STATE.free)
			else:
				var force = grab_force * polygon.global_transform.basis_xform_inv(((polygon.global_transform.xform(nodes[grabbed_node])) - get_global_mouse_position()))
				var force_dir = force.normalized()
				var force_str = force.length()
				deformer.forces[grabbed_node] = min(max_force, force_str) * force_dir
	polygon_display.set_polygon(polygon.get_polygon())
	var line_points = polygon.get_polygon()
	line_points.append(line_points[0])
	line.points = line_points

func _physics_process(delta):
	match state:
		STATE.free:
			deformer.free_motion()
		STATE.grabbed:
			deformer.deform()

func get_grabbed_node():
	var mouse_pos = get_global_mouse_position()
	var nodes_positions = polygon.get_polygon()
	for i in range(nodes.size()):
		var dist = (polygon.global_transform.xform(nodes_positions[i]) - mouse_pos).length()
		if dist < grab_radius and not deformer.get_pinned().has(i):
			return i
	return -1
