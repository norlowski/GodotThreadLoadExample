extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var  MeshinstanceOnly = preload("res://MeshinstanceOnly.tscn")
onready var AreaOnly = preload("res://AreaOnly.tscn")
onready var AreaWCollisionShape = preload("res://AreaWCollisionShape.tscn")
onready var Sprite3d = preload("res://Sprite3d.tscn")
onready var Sprite3dEmpty = preload("res://Sprite3dEmpty.tscn")


export var proceed_automatically:bool = false
export var load_using_thread:bool = true
var logger = Logger.get_logger("root.gd")

var thread:Thread


# Called when the node enters the scene tree for the first time.
func _ready():
	thread = Thread.new()
	if proceed_automatically:
		print('prceeding automatically')
		self._on_New_Game_pressed()
#
func _new_game(userargs):
	logger.info('in thread new game')

	for _scene in [MeshinstanceOnly,AreaOnly,AreaWCollisionShape,Sprite3dEmpty,Sprite3d]:
	
		logger.info(">>>>>>>>>>>>>>>> NEXT SCENE TYPE<<<<<<<<<<<<<<")
		for _i in range(0,5):
			logger.info('instancing node...')
			var game_instance = _scene.instance()
			logger.info('...node instanced')
			$GameContainer.add_child(game_instance)
			logger.info('child added')
	logger.info('instanced, starting new game')	
	call_deferred("_return_from_thread")

func _return_from_thread():
	print('returned from thread (INTRO)')	
	
	if thread.is_active():
		thread.wait_to_finish()
	print('finished waiting (INTRO)')

func _input(event):
	if Input.is_action_just_pressed("LeaveGame"):
		logger.info('leave game')
		for game in $GameContainer.get_children():
			game.queue_free()
			

func _on_New_Game_pressed():
	logger.info('new game button pressed')
	if load_using_thread:
		thread.start(self,"_new_game",{})
	else:
		_new_game({})
