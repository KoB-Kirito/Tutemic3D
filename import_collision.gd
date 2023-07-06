@tool
extends EditorScenePostImport

func _post_import(scene: Node) -> Object:
	var mesh = scene.get_child(0) as MeshInstance3D
	mesh.create_trimesh_collision()
	return scene
