package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class MonsterAnimation extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _PlayActionFrom = new armory.logicnode.PlayActionFromNode(this);
		_PlayActionFrom.preallocInputs(9);
		_PlayActionFrom.preallocOutputs(2);
		var _OnInit = new armory.logicnode.OnInitNode(this);
		_OnInit.preallocInputs(0);
		_OnInit.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_OnInit, _PlayActionFrom, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "Huggy"), _PlayActionFrom, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "Move_Huggy"), _PlayActionFrom, 0, 2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.IntegerNode(this, 0), _PlayActionFrom, 0, 3);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.IntegerNode(this, 80), _PlayActionFrom, 0, 4);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.25), _PlayActionFrom, 0, 5);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 0.5), _PlayActionFrom, 0, 6);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _PlayActionFrom, 0, 7);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, false), _PlayActionFrom, 0, 8);
		armory.logicnode.LogicNode.addLink(_PlayActionFrom, new armory.logicnode.NullNode(this), 0, 0);
		armory.logicnode.LogicNode.addLink(_PlayActionFrom, new armory.logicnode.NullNode(this), 1, 0);
	}
}