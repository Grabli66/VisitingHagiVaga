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
		var _StopAgent = new armory.logicnode.StopAgentNode(this);
		_StopAgent.preallocInputs(2);
		_StopAgent.preallocOutputs(1);
		var _Gate = new armory.logicnode.GateNode(this);
		_Gate.property0 = "Less Equal";
		_Gate.property1 = 9.999999747378752e-05;
		_Gate.preallocInputs(3);
		_Gate.preallocOutputs(2);
		var _OnUpdate = new armory.logicnode.OnUpdateNode(this);
		_OnUpdate.property0 = "Update";
		_OnUpdate.preallocInputs(0);
		_OnUpdate.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_OnUpdate, _Gate, 0, 0);
		var _GetDistance = new armory.logicnode.GetDistanceNode(this);
		_GetDistance.preallocInputs(2);
		_GetDistance.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "Игрок"), _GetDistance, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "Монстр"), _GetDistance, 0, 1);
		armory.logicnode.LogicNode.addLink(_GetDistance, _Gate, 0, 1);
		var _Float = new armory.logicnode.FloatNode(this);
		_Float.preallocInputs(1);
		_Float.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 1.5), _Float, 0, 0);
		armory.logicnode.LogicNode.addLink(_Float, _Gate, 0, 2);
		armory.logicnode.LogicNode.addLink(_Gate, _StopAgent, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "Монстр"), _StopAgent, 0, 1);
		armory.logicnode.LogicNode.addLink(_StopAgent, new armory.logicnode.NullNode(this), 0, 0);
		var _PlayActionFrom = new armory.logicnode.PlayActionFromNode(this);
		_PlayActionFrom.preallocInputs(9);
		_PlayActionFrom.preallocOutputs(2);
		armory.logicnode.LogicNode.addLink(_Gate, _PlayActionFrom, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "Huggy"), _PlayActionFrom, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "Attack_Huggy"), _PlayActionFrom, 0, 2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.IntegerNode(this, 0), _PlayActionFrom, 0, 3);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.IntegerNode(this, 26), _PlayActionFrom, 0, 4);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.25), _PlayActionFrom, 0, 5);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 1.0), _PlayActionFrom, 0, 6);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _PlayActionFrom, 0, 7);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, false), _PlayActionFrom, 0, 8);
		armory.logicnode.LogicNode.addLink(_PlayActionFrom, new armory.logicnode.NullNode(this), 0, 0);
		armory.logicnode.LogicNode.addLink(_PlayActionFrom, new armory.logicnode.NullNode(this), 1, 0);
		var _PlayActionFrom_001 = new armory.logicnode.PlayActionFromNode(this);
		_PlayActionFrom_001.preallocInputs(9);
		_PlayActionFrom_001.preallocOutputs(2);
		armory.logicnode.LogicNode.addLink(_Gate, _PlayActionFrom_001, 1, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "Huggy"), _PlayActionFrom_001, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "Move_Huggy"), _PlayActionFrom_001, 0, 2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.IntegerNode(this, 0), _PlayActionFrom_001, 0, 3);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.IntegerNode(this, 80), _PlayActionFrom_001, 0, 4);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.25), _PlayActionFrom_001, 0, 5);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 1.0), _PlayActionFrom_001, 0, 6);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _PlayActionFrom_001, 0, 7);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, false), _PlayActionFrom_001, 0, 8);
		armory.logicnode.LogicNode.addLink(_PlayActionFrom_001, new armory.logicnode.NullNode(this), 0, 0);
		armory.logicnode.LogicNode.addLink(_PlayActionFrom_001, new armory.logicnode.NullNode(this), 1, 0);
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