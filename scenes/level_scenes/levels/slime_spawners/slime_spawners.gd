extends Level

onready var slime_spawners := $Enemies.get_children()


func _ready() -> void:
	for slime_spawner in slime_spawners:
		slime_spawner.set_active(true)
