extends Node2D

export var camera_path : NodePath

onready var area = get_node("Area2D")
onready var sprite = get_node("AnimatedSprite")
onready var camera = get_node(camera_path)
onready var audio = get_node("AudioStreamPlayer")

enum STATE {
	idle,
	broken
}

var state

signal entered_state

func _enter_state(new_state):
	state = new_state
	emit_signal("entered_state", state)

func _ready():
	state = STATE.broken
	area.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	sprite.animation = "break"
	audio.play()
	camera.shake()
	body.queue_free()
	_enter_state(STATE.broken)
