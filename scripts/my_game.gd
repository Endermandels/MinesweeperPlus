extends Node
class_name MyGame

# Settings 
@export_range(0, 480) var mine_count: int = 99 ## Number of mines

# Internal Nodes
@export_group("Internal Nodes")
@export var grid: TileMapLayer
@export var win_screen_overlay: WinScreenOverlay

@onready var used_rect: Rect2i = grid.get_used_rect()

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var tile_data: Dictionary = {} ## tile_coords: Vector2i -> CustomTileData
var start_tile_coords: Vector2i = Vector2i(-1, -1)
var populating_grid: bool = false
var is_new_game: bool = true
var revealed_tiles: int = 0

func _unhandled_input(event: InputEvent) -> void:
    # When you've won or lost, no more clicking the grid
    if win_screen_overlay.hidden:
        if event.is_action_pressed("left_click"):
            _click_tile("left")
        if event.is_action_pressed("right_click"):
            _click_tile("right")

func _ready() -> void:
    for i in grid.get_used_cells():
        tile_data[i] = CustomTileData.new()

func _process(_delta: float) -> void:
    if populating_grid:
        _populate_grid()

func _click_tile(mouse_button: String) -> void:
    # Map coords for tile
    var tile_coords: Vector2i = grid.local_to_map(grid.get_local_mouse_position())

    if not _is_valid_tile(tile_coords):
        push_warning("Invalid tile: %s" % tile_coords)
        return

    if is_new_game:
        populating_grid = true
        start_tile_coords = tile_coords
        return
    
    if mouse_button == "left":
        _reveal_tile(tile_coords)
    elif mouse_button == "right":
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
    var data: CustomTileData = tile_data[tile_coords]

    if grid.get_cell_atlas_coords(tile_coords).x == 1:
        # print("Tile %s is revealed" % tile_coords)
        return

    if data.is_flagged:
        print("Tile %s is flagged" % tile_coords)
        return
    
    if data.is_mine:
        print("!!! Hit a mine at Tile %s" % tile_coords)
        return

    grid.set_cell(tile_coords, 1, Vector2i(1, 0), 0)
    print("Revealed: %s" % tile_coords)

    revealed_tiles += 1

    if _is_win():
        win_screen_overlay.reveal()
    
    if data.adjacent_mine_count == 0:
        for coords in _get_surrounding_cells(tile_coords):
            if not _is_valid_tile(coords):
                continue
            _reveal_tile(coords)

func _get_surrounding_cells(tile_coords: Vector2i) -> Array[Vector2i]:
    var coords: Array[Vector2i] = grid.get_surrounding_cells(tile_coords)
    coords.append(grid.get_neighbor_cell(tile_coords, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER))
    coords.append(grid.get_neighbor_cell(tile_coords, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER))
    coords.append(grid.get_neighbor_cell(tile_coords, TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER))
    coords.append(grid.get_neighbor_cell(tile_coords, TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER))
    return coords

func _is_win() -> bool:
    return revealed_tiles == used_rect.size.x * used_rect.size.y - mine_count

func _flag_tile(tile_coords: Vector2i) -> void:
    var data: CustomTileData = tile_data[tile_coords]

    if grid.get_cell_atlas_coords(tile_coords).x == 1:
        print("Tile %s is revealed" % tile_coords)
        return

    if data.is_flagged:
        data.is_flagged = false
        grid.set_cell(tile_coords, 1, Vector2i(0, 0), 0)
        print("Tile %s is now unflagged" % tile_coords)
    else:        
        data.is_flagged = true
        grid.set_cell(tile_coords, 1, Vector2i(0, 1), 0)
        print("Tile %s is now flagged" % tile_coords)

func _populate_grid() -> void:
    var remaining_mines = mine_count

    if remaining_mines > 0:
        # print("Populating grid")
        var mine_map_coords: Vector2i = Vector2i(rng.randi_range(0, used_rect.size.x - 1), rng.randi_range(0, used_rect.size.y - 1))
        var data: CustomTileData = tile_data[mine_map_coords]

        while mine_map_coords == start_tile_coords or data.is_mine:
            mine_map_coords = Vector2i(rng.randi_range(0, used_rect.size.x - 1), rng.randi_range(0, used_rect.size.y - 1))
            # print("Rerolled mine coords: %s" % mine_map_coords)
            data = tile_data[mine_map_coords]
            # print("Is mine: %s" % data.is_mine)

        # print("Tile %s now has a mine" % mine_map_coords)
        data.is_mine = true
        remaining_mines -= 1
        # print("Remaining mines: %d" % remaining_mines)
        return

    print("Finished populating grid")

    _reveal_tile(start_tile_coords)
    start_tile_coords = Vector2i(-1, -1)
    is_new_game = false
    populating_grid = false