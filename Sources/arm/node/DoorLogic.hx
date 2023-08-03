package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class DoorLogic extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _RotateObject = new armory.logicnode.RotateObjectNode(this);
		_RotateObject.property0 = "Local";
		_RotateObject.preallocInputs(3);
		_RotateObject.preallocOutputs(1);
		var _TweenRotation = new armory.logicnode.TweenRotationNode(this);
		_TweenRotation.property0 = "Linear";
		_TweenRotation.preallocInputs(5);
		_TweenRotation.preallocOutputs(4);
		var _IsTrue = new armory.logicnode.IsTrueNode(this);
		_IsTrue.preallocInputs(2);
		_IsTrue.preallocOutputs(1);
		var _OnUpdate = new armory.logicnode.OnUpdateNode(this);
		_OnUpdate.property0 = "Update";
		_OnUpdate.preallocInputs(0);
		_OnUpdate.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_OnUpdate, _IsTrue, 0, 0);
		var _GetObjectProperty = new armory.logicnode.GetPropertyNode(this);
		_GetObjectProperty.preallocInputs(2);
		_GetObjectProperty.preallocOutputs(2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _GetObjectProperty, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "is_on"), _GetObjectProperty, 0, 1);
		armory.logicnode.LogicNode.addLink(_GetObjectProperty, new armory.logicnode.StringNode(this, ""), 1, 0);
		armory.logicnode.LogicNode.addLink(_GetObjectProperty, _IsTrue, 0, 1);
		armory.logicnode.LogicNode.addLink(_IsTrue, _TweenRotation, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.NullNode(this), _TweenRotation, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.RotationNode(this, 0.0,0.0,0.0,1.0), _TweenRotation, 0, 2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.RotationNode(this, 0.0,0.0,0.5,0.7071067690849304), _TweenRotation, 0, 3);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.10000000149011612), _TweenRotation, 0, 4);
		armory.logicnode.LogicNode.addLink(_TweenRotation, new armory.logicnode.NullNode(this), 0, 0);
		armory.logicnode.LogicNode.addLink(_TweenRotation, _RotateObject, 1, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _RotateObject, 0, 1);
		armory.logicnode.LogicNode.addLink(_TweenRotation, _RotateObject, 3, 2);
		armory.logicnode.LogicNode.addLink(_RotateObject, new armory.logicnode.NullNode(this), 0, 0);
		var _SetObjectProperty = new armory.logicnode.SetPropertyNode(this);
		_SetObjectProperty.preallocInputs(4);
		_SetObjectProperty.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_TweenRotation, _SetObjectProperty, 2, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _SetObjectProperty, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "is_on"), _SetObjectProperty, 0, 2);
		var _Boolean = new armory.logicnode.BooleanNode(this);
		_Boolean.preallocInputs(1);
		_Boolean.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, false), _Boolean, 0, 0);
		armory.logicnode.LogicNode.addLink(_Boolean, _SetObjectProperty, 0, 3);
		armory.logicnode.LogicNode.addLink(_SetObjectProperty, new armory.logicnode.NullNode(this), 0, 0);
		var _Print = new armory.logicnode.PrintNode(this);
		_Print.preallocInputs(2);
		_Print.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_TweenRotation, _Print, 2, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "DONE"), _Print, 0, 1);
		armory.logicnode.LogicNode.addLink(_Print, new armory.logicnode.NullNode(this), 0, 0);
	}
}