extends Control
class_name PauseMenu

# Settings 
@export var esc_to_open: bool ## If [code]true[/code], pressing ESC will toggle the pause menu

# Internal Nodes
@export_group("Internal Nodes")
@export var settings_button: Button ## TODO: Implement
@export var main_menu_button: Button
@export var return_button: Button

func _unhandled_key_input(event: InputEvent) -> void:
    if esc_to_open and event.is_action_pressed("ui_cancel"):
        visible = not visible

func _ready() -> void:
    hide()
    return_button.pressed.connect(hide)
    main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func _on_main_menu_button_pressed() -> void:
    get_tree().change_scene_to_file(SceneFileNames.main_menu)
