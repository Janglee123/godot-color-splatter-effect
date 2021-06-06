class_name ParticleCollider extends Area2D

signal particle_collided

var collided_canvas: Sprite
var collided_layer: SplatLayer
var global_collision_position: Vector2
var relative_collision_position: Vector2
var canvas_light_mask: int
var has_collided := false


func set_disabled(value: bool) -> void:
	monitorable = !value
	monitoring = !value


func _on_body_entered(body: TileMap):
	collided_layer = body.get_node('SplatLayer') as SplatLayer
	collided_canvas = body.get_node('SplatLayer/Canvas') as Sprite
	global_collision_position = global_position
	relative_collision_position = global_position - collided_canvas.global_position 
	canvas_light_mask = collided_canvas.light_mask
	emit_signal('particle_collided')


func draw_spot_at_collision(spot: Texture) -> void:
	draw_spot(collided_canvas.texture, spot, relative_collision_position)


func draw_spot(target: Texture, spot: Texture, pos: Vector2) -> void:
	var size = spot.get_size()
	var dst = pos - size/2
	
	var traget_img := target.get_data()
	traget_img.blend_rect(spot.get_data(), Rect2(Vector2.ZERO, size), dst)
	VisualServer.texture_set_data(target.get_rid(), traget_img)
#	VisualServer.texture_set_data_partial(
#		target.get_rid(), spot.get_data(), 
#		0, 0,
#		size.x, size.y, 
#		dst.x, dst.y,
#		0, 0)


func _on_tree_entered():
	has_collided = false
