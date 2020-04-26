extends Node2D

export var goal_path : NodePath

onready var goal = get_node(goal_path)

signal finished

func _ready():
	goal.connect("entered_state", self, "check_goal")

func check_goal(goal_state):
	if goal_state == goal.STATE.broken:
		yield(get_tree().create_timer(1.2), "timeout")
		emit_signal("finished")
