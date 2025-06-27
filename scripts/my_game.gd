extends Node
class_name MyGame

@export_group("Internal Nodes")
@export var grid: TileMapLayer

@onready var used_rect := grid.get_used_rect()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("left_click"):
        _left_click_tile(event.position)

func _left_click_tile(coords: Vector2) -> void:
    var tile_coords = grid.local_to_map(        # Get tile map position of clicked tile
        grid.to_local(Vector2i(coords)          # Relative to the grid's position
        )
    )
    print(tile_coords)
    if not _is_valid_tile(tile_coords):
        print("Not valid tile")
        return
    print("Is valid tile")

func _is_valid_tile(tile_coords: Vector2i) -> bool:
    return (
        tile_coords.x < used_rect.size.x and
        tile_coords.x >= 0 and
        tile_coords.y < used_rect.size.y and
        tile_coords.y >= 0
    )