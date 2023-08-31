package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class BoneIK extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _BoneIK = new armory.logicnode.BoneIKNode(this);
		_BoneIK.preallocInputs(10);
		_BoneIK.preallocOutputs(1);
		var _OnUpdate = new armory.logicnode.OnUpdateNode(this);
		_OnUpdate.property0 = "Late Update";
		_OnUpdate.preallocInputs(0);
		_OnUpdate.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_OnUpdate, _BoneIK, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _BoneIK, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "mixamorig:LeftForeArm"), _BoneIK, 0, 2);
		var _GetObjectLocation = new armory.logicnode.GetLocationNode(this);
		_GetObjectLocation.preallocInputs(2);
		_GetObjectLocation.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "AimLeft"), _GetObjectLocation, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, false), _GetObjectLocation, 0, 1);
		armory.logicnode.LogicNode.addLink(_GetObjectLocation, _BoneIK, 0, 3);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, false), _BoneIK, 0, 4);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.VectorNode(this, 0.0,0.0,0.0), _BoneIK, 0, 5);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.IntegerNode(this, 2), _BoneIK, 0, 6);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.IntegerNode(this, 10), _BoneIK, 0, 7);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.009999999776482582), _BoneIK, 0, 8);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.0), _BoneIK, 0, 9);
		armory.logicnode.LogicNode.addLink(_BoneIK, new armory.logicnode.NullNode(this), 0, 0);
		var _BoneIK_001 = new armory.logicnode.BoneIKNode(this);
		_BoneIK_001.preallocInputs(10);
		_BoneIK_001.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_OnUpdate, _BoneIK_001, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _BoneIK_001, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "mixamorig:RightForeArm"), _BoneIK_001, 0, 2);
		var _GetObjectLocation_001 = new armory.logicnode.GetLocationNode(this);
		_GetObjectLocation_001.preallocInputs(2);
		_GetObjectLocation_001.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "AimRight"), _GetObjectLocation_001, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, false), _GetObjectLocation_001, 0, 1);
		armory.logicnode.LogicNode.addLink(_GetObjectLocation_001, _BoneIK_001, 0, 3);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, false), _BoneIK_001, 0, 4);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.VectorNode(this, 0.0,0.0,0.0), _BoneIK_001, 0, 5);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.IntegerNode(this, 2), _BoneIK_001, 0, 6);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.IntegerNode(this, 10), _BoneIK_001, 0, 7);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.009999999776482582), _BoneIK_001, 0, 8);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.0), _BoneIK_001, 0, 9);
		armory.logicnode.LogicNode.addLink(_BoneIK_001, new armory.logicnode.NullNode(this), 0, 0);
	}
}