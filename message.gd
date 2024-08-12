extends PanelContainer

@onready var label: Label = %Label
@onready var panel: Panel = %Panel

var bot: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Panel.modulate = Color.SKY_BLUE if bot else Color.WHITE
