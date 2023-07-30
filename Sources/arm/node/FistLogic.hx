package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class FistLogic extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _SetObjectProperty = new armory.logicnode.SetPropertyNode(this);
		_SetObjectProperty.preallocInputs(4);
		_SetObjectProperty.preallocOutputs(1);
		var _OnContact = new armory.logicnode.OnContactNode(this);
		_OnContact.property0 = "begin";
		_OnContact.preallocInputs(2);
		_OnContact.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "Игрок"), _OnContact, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _OnContact, 0, 1);
		armory.logicnode.LogicNode.addLink(_OnContact, _SetObjectProperty, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "Игрок"), _SetObjectProperty, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "is_hit"), _SetObjectProperty, 0, 2);
		var _Boolean = new armory.logicnode.BooleanNode(this);
		_Boolean.preallocInputs(1);
		_Boolean.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _Boolean, 0, 0);
		armory.logicnode.LogicNode.addLink(_Boolean, _SetObjectProperty, 0, 3);
		armory.logicnode.LogicNode.addLink(_SetObjectProperty, new armory.logicnode.NullNode(this), 0, 0);
	}
}