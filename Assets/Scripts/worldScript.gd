extends Spatial

var exportList = [
	preload('res://Api/Multiplayer.gd').new(),
	preload('res://Api/Settings.gd').new(),
	preload('res://Api/Player.gd').new(),
]

onready var global = {
	'camera': get_node('/root/world/Player/Collision/Camera'),
	'player': get_node('/root/world/Player'),
	'online': get_node('/root/world/Online'),
	'world': get_node('/root/world'),
}

func _ready():
	for out in exportList: out.exports(global) ; 
	JavaScript.eval('window.ongameloaded()')
	pass
