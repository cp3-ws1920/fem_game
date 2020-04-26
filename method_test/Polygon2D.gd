extends Polygon2D

onready var deformer = get_node("ElasticBody2D")


# Called when the node enters the scene tree for the first time.
func _ready():
	var forces = deformer.get_forces()
	forces.set(1, Vector2(10000.0, 0.0))
	deformer.forces = forces
	deformer.deform()


func _physics_process(delta):
	deformer.free_motion()
