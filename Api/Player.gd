extends Node

var global ; var exportList = [
	['set_position',JavaScript.create_callback(self,'set_position')],
	['set_rotation',JavaScript.create_callback(self,'set_rotation')],
	
	['can_rotate',JavaScript.create_callback(self,'can_rotate')],
	['can_move',JavaScript.create_callback(self,'can_move')],
	
	['rotate_to',JavaScript.create_callback(self,'rotate_to')],
	['move_to',JavaScript.create_callback(self,'move_to')],
	
	['get_state',JavaScript.create_callback(self,'get_state')],
	['set_camera',JavaScript.create_callback(self,'set_camera')],
]
	
#────────────────────────────────────────────────────────────────────#

func get_state(args):
	var player = JavaScript.get_interface('player')
	var state = JavaScript.create_object('Object')
	
	state.position = JavaScript.create_object('Array',3)
	state.position[0] = global.player.translation.x
	state.position[1] = global.player.translation.y
	state.position[2] = global.player.translation.z
	
	state.rotation = JavaScript.create_object('Array',3)
	state.rotation[0] = global.player.rotation.x
	state.rotation[1] = global.player.rotation.y
	state.rotation[2] = global.player.rotation.z
	
	player.set(state)

#────────────────────────────────────────────────────────────────────#

func set_camera(args):
	var cam = global.camera ; if args[0] != 0:
		cam = instance_from_id(args[0]) 
	cam.set_fov(75) ; cam.set_znear(0.01)
	cam.set_current(args[1])
	cam.set_current(args[1])

#────────────────────────────────────────────────────────────────────
func can_move(args):
	global.player.status.move = args[0]

func can_rotate(args):
	global.player.status.mouse = args[0]
	
#────────────────────────────────────────────────────────────────────#
	
func move_to(args):
	var angle = cartesian2polar(args[0][0],args[0][1])
	if args[0][0] == 0 and args[0][1] == 0:
		global.player.status.speed = 0
	else: 
		global.player.status.speed = args[1]
	global.player.status.angle = angle.y
	
func rotate_to(args):
	global.player.status.relative = Vector2( args[0][0], args[0][1] )
	global.player.status.sensibility = args[1]

#────────────────────────────────────────────────────────────────────#

func set_position(args):
	var pos = Vector3( args[0],args[1],args[2] )
	global.player.translation = pos
	
func set_rotation(args):
	global.camera.rotation.x = deg2rad(args[0])
	global.player.rotation.y = deg2rad(args[1])

#────────────────────────────────────────────────────────────────────#	

func exports( options ): 
	var win = JavaScript.get_interface('window')
	win.godot.player = JavaScript.create_object('Object')
	global = options ; for function in exportList:
		win.godot.player[function[0]] = function[1]
