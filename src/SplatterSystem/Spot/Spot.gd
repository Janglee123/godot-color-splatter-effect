extends Node2D
class_name Spot

signal spot_collided

const MAX_SPEED: = 10
const MIN_SPEED: = 5
const ACC: = 20.0

var _velocity: Vector2
var _true_scale: Vector2
var _acc: Vector2
var _area
var _smooth: = 0.9

func _ready() -> void:
	z_as_relative = false
	$Sprite.frame = randi() % 8
	
	_true_scale = Vector2.ONE*(0.1 + randf())
	scale = _true_scale
	_area = _true_scale.x*_true_scale.y
	get_frame_rect()


func _physics_process(delta: float) -> void:
	_velocity += _acc*delta
	position += _velocity
	var W = _true_scale.x + abs(_velocity.x)/20
	var H = _area/W
	H += abs(_velocity.y)/20
	W = _area/H
	
	scale = _smooth*scale + (1.0 - _smooth)*Vector2(W, H)


func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	emit_signal("spot_collided", self)
	queue_free()


func set_directions(vel: Vector2, acc: Vector2) -> void:
	_velocity = vel.normalized()
	_velocity *= rand_range(MIN_SPEED, MAX_SPEED)
	_acc = acc*ACC


func get_frame_rect() -> Rect2:
	var sprite: = $Sprite
	var x = sprite.frame % sprite.hframes
	var w = sprite.texture.get_width() / sprite.hframes
	var y = int(sprite.frame / sprite.vframes)
	var h = sprite.texture.get_height() / sprite.vframes
	return Rect2(x * w, y * h, scale.x * w, scale.y * h)


func draw_spot(base: Image, dst: Vector2) -> void:
	var texture: Image = $Sprite.get_texture().get_data()
	base.blit_rect(texture, get_frame_rect(), dst)