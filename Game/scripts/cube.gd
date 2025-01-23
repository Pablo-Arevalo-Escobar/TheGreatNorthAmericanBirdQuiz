extends Node3D

@export var ray_length: float = 10.0 # Max distance for raycast
@export var ground_layer: int = 1 # Set to the correct physics layer
var space_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# cast a raytrace down to the incline plane.
	space_state = get_world_3d().direct_space_state
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var from = global_transform.origin
	var to = from - Vector3(0,ray_length,0) # cast down
	
	var query = PhysicsRayQueryParameters3D.create(from,to)
	query.collision_mask = ground_layer 
	
	var result = space_state.intersect_ray(query)
	pass
