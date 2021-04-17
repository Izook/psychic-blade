extends Level

onready var enemies := $Enemies.get_children()
onready var enemies_defeated := 0

func _ready() -> void:
	for enemy in enemies:
		enemy.connect("died", self, "_on_Enemy_died")


func _on_Enemy_died() -> void:
	enemies_defeated += 1
	
	if enemies_defeated >= enemies.size():
		_complete_level()
