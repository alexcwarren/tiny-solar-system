class_name ErrorDialog
extends AcceptDialog


func _no_op() -> void:
	return


func _init(text: String, parent_node: Node, function: Callable = _no_op) -> void:
	self.title = "ERROR"
	self.dialog_text = text
	self.confirmed.connect(function)
	parent_node.add_child(self)
	self.popup_centered()
