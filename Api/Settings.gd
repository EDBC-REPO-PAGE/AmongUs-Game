extends Node

var global ; var exportList = [
	['set_mouse',JavaScript.create_callback( self,'set_mouse')],
	['set_music',JavaScript.create_callback( self,'set_music')],
	['set_sfx',JavaScript.create_callback( self,'set_sfx')],
	['set_ui',JavaScript.create_callback( self,'set_ui')],
]

#────────────────────────────────────────────────────────────────────#

func set_mouse(args):
	print(args[0])

func set_music(args):
	print(args[0])

func set_sfx(args):
	print(args[0])

func set_ui(args):
	print(args[0])
	
#────────────────────────────────────────────────────────────────────#	

func exports( options ):
	var win = JavaScript.get_interface('window')
	win.godot.settings = JavaScript.create_object('Object')
	global = options ; for function in exportList:
		win.godot.settings[function[0]] = function[1]
