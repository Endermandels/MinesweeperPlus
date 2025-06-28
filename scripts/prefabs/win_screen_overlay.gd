extends Control
class_name WinScreenOverlay

# Internal Nodes
@export_group("Internal Nodes")
@export var reset_button: Button
@export var exit_button: Button
@export var time_label: Label

var time_acc: float = 0.0

func _ready() -> void:
    hide()
    reset_button.pressed.connect(_on_reset_button_pressed)
    exit_button.pressed.connect(_on_exit_button_pressed)

func _process(delta: float) -> void:
    time_acc = clampf(time_acc + delta, 0.0, 5999.0)
    print(time_acc)

func reveal() -> void:
    var seconds: int = roundi(fmod(time_acc, 60))
    var minutes: int = roundi(time_acc / 60)
    print("Seconds: %d Minutes: %d" % [seconds, minutes])
    time_label.text = "        %s:%s" % [minutes, seconds] 
    show()

func _on_reset_button_pressed() -> void:
    get_tree().change_scene_to_file(SceneFileNames.game)

func _on_exit_button_pressed() -> void:
    get_tree().change_scene_to_file(SceneFileNames.main_menu)
