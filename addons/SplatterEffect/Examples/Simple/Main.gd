extends Node2D

export(PackedScene) var Particle

var _particles: Array
var vel := 0.0


func _process(delta):
	var p_pos = $Cloud.global_position
	var new_pos = get_global_mouse_position()
	$Cloud.global_position = lerp($Cloud.global_position, new_pos, 2 * get_process_delta_time())
	vel = (new_pos - p_pos).x * 0.1
	vel = clamp(vel, -3, 3)


func _on_Timer_timeout():
	
	var start = randi() % 2
	var end = $Cloud.get_child_count()
	
	for i in range(start, end, 2):
		var spot_pos = $Cloud.get_child(i).global_position
		var p = Particle.instance() as Sprite
		add_child(p)
		p.global_position = spot_pos
		p._velocity = Vector2(vel, 5)
