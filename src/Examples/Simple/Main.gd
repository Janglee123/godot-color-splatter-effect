extends Node2D

export(PackedScene) var ParticleRed
export(PackedScene) var ParticleBlue
export(PackedScene) var ParticleGreen
export(PackedScene) var ParticleYellow

var _particles: Array


func _ready():
	_particles = [ParticleRed, ParticleBlue, ParticleGreen, ParticleYellow]


func _input(_event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var pos = get_viewport().get_mouse_position()
		var p = _particles[randi() % 4].instance() as Sprite
		add_child(p)
		p.global_position = pos

