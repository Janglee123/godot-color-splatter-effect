extends Sprite

var _velocity: Vector2
var _acc: Vector2
var spot_collide_texture: Texture

func _ready():
	_velocity = Vector2(randf() - 0.5, randf() - 0.5)
	_velocity = 3 * _velocity.normalized()
	_acc = Vector2.DOWN * 5


func _physics_process(delta: float) -> void:
	_velocity += _acc*delta
	position += _velocity
	_squze()


func _squze() -> void:
	
	var W = 1.0 + abs(_velocity.x) / 30
	var H = 1.0 / W
	H += abs(_velocity.y)/30
	W = 1.0 / H
	scale = lerp(scale, Vector2(W, H), 0.9)


func _on_Timer_timeout():
	queue_free()


func _on_ParticleCollider_particle_collided():
	set_physics_process(false)
	$ParticleCollider.call_deferred('set_disabled', true)
	light_mask = $ParticleCollider.canvas_light_mask
	$Tween.interpolate_property(self, 'scale', Vector2.ONE * 0.2, Vector2.ONE, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()


func _on_Tween_tween_all_completed():
	$ParticleCollider.draw_spot_at_collision(texture)
	queue_free()
