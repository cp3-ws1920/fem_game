extends Node2D

onready var levels = [preload("res://levels/Level1.tscn"), preload("res://levels/Level2.tscn"), preload("res://levels/Level3.tscn")]

onready var level_container = get_node("Level")

onready var level_progress = get_node("LevelProgress")
onready var tex_level_active = preload("res://assets/level_active.png")
onready var tex_level_inactive = preload("res://assets/level_inactive.png")

func load_level(idx):
	if (idx > levels.size() - 1):
		get_tree().change_scene("res://scenes/ThanksForPlaying.tscn")
		return
	for i in range(level_container.get_child_count()):
		level_container.remove_child(level_container.get_child(i))
	level_container.add_child(levels[idx].instance())
	for i in range(levels.size()):
		level_progress.get_child(i).texture = tex_level_inactive
	level_progress.get_child(idx).texture = tex_level_active
	level_container.get_child(0).connect("finished", self, "load_level", [idx + 1])

func _ready():
	var xpos = 0.0
	for i in range(levels.size()):
		var level_sprite = Sprite.new()
		level_sprite.texture = tex_level_inactive
		level_sprite.position.x = xpos
		level_progress.add_child(level_sprite)
		xpos += 10

	load_level(0)
