extends Node2D

export (NodePath) var Target
export (PackedScene) var Spot

const SNAP: = Vector2(5,5)
const Z_INDEX = -1

var _history = Array()
var _spots_layer: Image


func _ready() -> void:
	var tile_map : TileMap = get_node(Target)
	var itex: = create_image_texture_from_tilemap(tile_map)
	set_mask(itex, Z_INDEX)
	tile_map.z_index = Z_INDEX - 1
	_spots_layer = get_viewport_size_image()
	$SpotsLayer.z_as_relative = false
	$SpotsLayer.z_index = Z_INDEX

func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		var pos = get_viewport().get_mouse_position()
		throw_particals(pos, Vector2.UP, Vector2.DOWN, PI/4, 2)

func _on_spot_collide(spot: Spot):
	var pos = spot.position
	if _history.has(pos.snapped(SNAP)): 
		return
	_history.append(pos)
	spot.draw_spot(_spots_layer, pos)
	$SpotsLayer.texture.create_from_image(_spots_layer)


func set_mask(itex: ImageTexture, range_z: int) -> void:
	$Mask.set_texture(itex)
	$Mask.position = itex.get_size()/2
	$Mask.range_z_max = range_z
	$Mask.range_z_min = range_z


func get_viewport_size_image() -> Image:
	var img: = Image.new()
	var size: Vector2 = get_viewport_rect().size
	img.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	return img


func get_base_image_from_tilemap(tile_map: TileMap) -> Image:
	var img: = get_viewport_size_image()
	var cell_size: = tile_map.get_cell_size()
	var offset: = tile_map.position
	var white: Image = $White.get_texture().get_data()
	var mask: = white.get_used_rect()
	
	for tile in tile_map.get_used_cells():
		img.blit_rect(white, mask, tile*cell_size + offset)
	
	return img


func create_image_texture_from_tilemap(tile_map: TileMap) -> ImageTexture:
	if not tile_map is TileMap:
		return null
	
	var img: = get_base_image_from_tilemap(tile_map)
	var itex: = ImageTexture.new()
	itex.create_from_image(img)
	
	return itex


func throw_particals(pos: Vector2, direction: Vector2, acc: Vector2, deflect_range: float, n: int):
	for i in range(n):
		var dir: = direction.rotated(rand_range(-deflect_range/2, deflect_range/2))
		var p: = get_partical(pos, dir, acc)
		$Spots.add_child(p)


func get_partical(pos: Vector2, vel: Vector2, acc: Vector2) -> Node2D:
	var new_spot: Node2D = Spot.instance()
	new_spot.set_directions(vel, acc)
	new_spot.global_position = pos
	new_spot.connect("spot_collided", self, "_on_spot_collide")
	return new_spot
