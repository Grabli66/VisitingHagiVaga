package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class FollowNode extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _GotoLocation = new armory.logicnode.GoToLocationNode(this);
		_GotoLocation.preallocInputs(9);
		_GotoLocation.preallocOutputs(3);
		var _IsNotNull = new armory.logicnode.IsNotNoneNode(this);
		_IsNotNull.preallocInputs(2);
		_IsNotNull.preallocOutputs(1);
		var _OnTimer = new armory.logicnode.OnTimerNode(this);
		_OnTimer.preallocInputs(2);
		_OnTimer.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.5), _OnTimer, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _OnTimer, 0, 1);
		armory.logicnode.LogicNode.addLink(_OnTimer, _IsNotNull, 0, 0);
		var _GetObjectLocation = new armory.logicnode.GetLocationNode(this);
		_GetObjectLocation.preallocInputs(2);
		_GetObjectLocation.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "Игрок"), _GetObjectLocation, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, false), _GetObjectLocation, 0, 1);
		armory.logicnode.LogicNode.addLink(_GetObjectLocation, _IsNotNull, 0, 1);
		armory.logicnode.LogicNode.addLink(_IsNotNull, _GotoLocation, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _GotoLocation, 0, 1);
		armory.logicnode.LogicNode.addLink(_GetObjectLocation, _GotoLocation, 0, 2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 1.0), _GotoLocation, 0, 3);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.4000000059604645), _GotoLocation, 0, 4);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.0), _GotoLocation, 0, 5);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, false), _GotoLocation, 0, 6);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, -5.0), _GotoLocation, 0, 7);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.IntegerNode(this, 1), _GotoLocation, 0, 8);
		armory.logicnode.LogicNode.addLink(_GotoLocation, new armory.logicnode.NullNode(this), 0, 0);
		armory.logicnode.LogicNode.addLink(_GotoLocation, new armory.logicnode.NullNode(this), 1, 0);
		armory.logicnode.LogicNode.addLink(_GotoLocation, new armory.logicnode.NullNode(this), 2, 0);
	}
}