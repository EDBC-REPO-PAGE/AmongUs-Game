extends Node

var shader = load("res://Assets/Shader/online.tres")
var online = load("res://Assets/characters/Online.tscn")
var material = load("res://Import/skeld_map/Online.tres")

var global ; var playerList = {} ; var exportList = [
	['add_player',JavaScript.create_callback(self,'add_player')],
	['set_player',JavaScript.create_callback(self,'set_player')],
	['get_player',JavaScript.create_callback(self,'get_player')],
	['del_player',JavaScript.create_callback(self,'del_player')],
]

#────────────────────────────────────────────────────────────────────#

func _updatePlayer(id):
	var player = playerList[id]
	player.instance.rotation = player.rotation
	player.instance.translation = player.position
	player.material.set_shader_param('alpha',player.alpha)
	player.material.set_shader_param('color',player.color)

func _getVec3(arg):
	return Vector3( arg[0], arg[1], arg[2] )

#────────────────────────────────────────────────────────────────────#	

func add_player(args):
	if !playerList.has(args[0].id): 
		playerList[args[0].id] = {
			'alpha': args[0].alpha,
			'instance': online.instance(),
			'animation': args[0].animation,
			'material': ShaderMaterial.new(),
			'color': _getVec3(args[0].color),
			'position': _getVec3(args[0].position),
			'rotation': _getVec3(args[0].rotation),
		}
		playerList[args[0].id].material.set_shader(shader)
		global.online.add_child(playerList[args[0].id].instance)
		playerList[args[0].id].instance.get_node('body').set_material(
			playerList[args[0].id].material
		)
	
	else: 
		playerList[args[0].id].rotation = _getVec3(args[0].rotation)
		playerList[args[0].id].position = _getVec3(args[0].position)
		playerList[args[0].id].color = _getVec3(args[0].color)
		playerList[args[0].id].animation = args[0].animation
		playerList[args[0].id].alpha = args[0].alpha
	
	_updatePlayer(args[0].id)
	pass

func del_player(args):
	if !playerList.has(args[0].id): return 0
	playerList[args[0].id].instance.queue_free()
	playerList.erase( args[0].id )
	pass

func get_player(args):
	var multiplayer = JavaScript.create_object('Object')
	var win = JavaScript.get_interface('window')
	for key in playerList:
		
		multiplayer[key] = JavaScript.create_object('Object')
		multiplayer[key].animation = playerList[key].animation
		multiplayer[key].alpha = playerList[key].alpha
		
		var color = JavaScript.create_object('Array',3)
		color[0] = playerList[key].color.x
		color[1] = playerList[key].color.y
		color[2] = playerList[key].color.z
		multiplayer[key].color = color
		
		var position = JavaScript.create_object('Array',3)
		position[0] = playerList[key].position.x
		position[1] = playerList[key].position.y
		position[2] = playerList[key].position.z
		multiplayer[key].position = position
		
		var rotation = JavaScript.create_object('Array',3)
		rotation[0] = playerList[key].rotation.x
		rotation[1] = playerList[key].rotation.y
		rotation[2] = playerList[key].rotation.z
		multiplayer[key].rotation = rotation
		
	win.multiplayer.set(multiplayer)
	pass

#────────────────────────────────────────────────────────────────────#	

func exports( options ): 
	var win = JavaScript.get_interface('window')
	win.godot.multiplayer = JavaScript.create_object('Object')
	global = options ; for function in exportList:
		win.godot.multiplayer[function[0]] = function[1]
