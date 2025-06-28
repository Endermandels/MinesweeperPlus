extends Node
class_name MyGame

@export_group("Internal Nodes")
@export var grid: TileMapLayer

@onready var used_rect := grid.get_used_rect()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("left_click"):
        _click_tile("right")
    if event.is_action_pressed("right_click"):
        _click_tile("left")

func _click_tile(mouse_button: String) -> void:
    # Map coords for tile
    var tile_coords := grid.local_to_map(grid.get_local_mouse_position())

    if not _is_valid_tile(tile_coords):
        push_warning("Invalid tile: %s" % tile_coords)
        return
    
    if mouse_button == "right":
        _reveal_tile(tile_coords)
    elif mouse_button == "left":
        _flag_tile(tile_coords)
    else:
        push_warning("Unknown mouse button: %s" % mouse_button)

func _is_valid_tile(tile_coords: Vector2i) -> bool:
    return (
        tile_coords.x < used_rect.size.x and
        tile_coords.x >= 0 and
        tile_coords.y < used_rect.size.y and
        tile_coords.y >= 0
    )

func _reveal_tile(tile_coords: Vector2i) -> void:
    var data := grid.get_cell_tile_data(tile_coords)
    if not data:
        push_error("Tile data not found at tile coords: %s" % tile_coords)
        return

    if grid.get_cell_atlas_coords(tile_coords).x == 1:
        print("Tile %s is revealed" % tile_coords)
        return

    if (data.get_custom_data("is_flagged")):
        print("Tile %s is flagged" % tile_coords)
        return

    grid.set_cell(tile_coords, 1, Vector2i(1, 0), 0)
    print("Revealed: %s" % tile_coords)

func _flag_tile(tile_coords: Vector2i) -> void:
    var data := grid.get_cell_tile_data(tile_coords)

    if not data:
        push_error("Tile data not found at tile coords: %s" % tile_coords)
        return

    if grid.get_cell_atlas_coords(tile_coords).x == 1:
        print("Tile %s is revealed" % tile_coords)
        return

    if (data.get_custom_data("is_flagged")):
        data.set_custom_data("is_flagged", false)
        print("Tile %s is now unflagged" % tile_coords)
        grid.set_cell(tile_coords, 1, Vector2i(0, 0), 0)
    else:        
        data.set_custom_data("is_flagged", true)
        print("Tile %s is now flagged" % tile_coords)
        grid.set_cell(tile_coords, 1, Vector2i(0, 1), 0)
