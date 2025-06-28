extends Node
class_name MainMenu

# Internal Nodes
@export_group("Internal Nodes")
@export var play_button: Button
@export var settings_button: Button
@export var quit_button: Button

func _unhandled_key_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()

func _ready() -> void:
    play_button.pressed.connect(_on_play_button_pressed)
    quit_button.pressed.connect(get_tree().quit)

func _on_play_button_pressed() -> void:
    get_tree().change_scene_to_file(SceneFileNames.game)
