class_name SplatLayer extends Node2D

export(int) var padding = 32

onready var _canvas = $Canvas
onready var _mask = $Mask

var _tile_map: TileMap

func _ready():
	_tile_map = get_parent()
	var tile_map_rect = _tile_map.get_used_rect()
	var tile_map_size = tile_map_rect.size*_tile_map.cell_size
	
	
	var itex := ImageTexture.new()
	var c_img := _create_image(tile_map_size + Vector2.ONE * 2 * padding)
	itex.create_from_image(c_img)
	_canvas.texture = itex
	_canvas.position = tile_map_rect.position * _tile_map.cell_size - Vector2.ONE * padding

	var img_tex = _copy_tile_map_to_texture(_tile_map)
	_mask.texture = img_tex
	_mask.position = _canvas.position + img_tex.get_size() / 2 


func _create_image(size: Vector2) -> Image:
	var img := Image.new()
	
	img.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	return img


func _copy_tile_map_to_texture(tile_map: TileMap) -> ImageTexture:
	
	var cell_size := tile_map.get_cell_size()
	var tile_set := tile_map.tile_set
	var used_rect := tile_map.get_used_rect()
	var pad = Vector2.ONE * padding
	var img := _create_image(used_rect.size * cell_size + 2 * pad)
	
	for tile in tile_map.get_used_cells():
		var tile_id := tile_map.get_cellv(tile)
		var tile_tex := tile_set.tile_get_texture(tile_id)
		var dst = tile*cell_size - used_rect.position * cell_size + pad  
		img.blit_rect(tile_tex.get_data(), Rect2(Vector2.ZERO, tile_tex.get_size()), dst)
	
	var itex := ImageTexture.new()
	itex.create_from_image(img)
	
	return itex
