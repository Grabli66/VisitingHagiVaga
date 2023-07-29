package arm;

import iron.math.Mat4;
import iron.object.BoneAnimation;
import iron.math.Vec4;
import iron.math.Quat;
import iron.system.Input;
import iron.object.Object;
import iron.object.CameraObject;
import armory.trait.physics.PhysicsWorld;
import armory.trait.internal.CameraController;

// Состояние игрока
enum PlayerState {
	None;
	Idle;
	Walk;
	Shoot;
	Reload;
	Dead;
}

// Логика игрока
class PlayerLogic extends CameraController {
	// Камера
	var head:Object;

	// Скорость поворота
	@prop
	var rotationSpeed = 2.0;

	var armature:Object;
	var animations:BoneAnimation;
	// Прицел для IK
	var aimNode:Object;

	// Начальная позиция прицела
	var initAimLoc:Vec4;

	// Состояние
	var state = PlayerState.None;

	// Скорость передвижения
	@prop
	public var speed:Float = 3;

	// Ищет анимацию
	function findAnimation(o:Object):BoneAnimation {
		if (o.animation != null)
			return cast o.animation;
		for (c in o.children) {
			var co = findAnimation(c);
			if (co != null)
				return co;
		}
		return null;
	}

	// Переходит в состояние Idle
	function startIdle() {
		if (state == Idle)
			return;

		state = Idle;
		animations.play('Idle_Policeman');
	}

	// Переходит в состояние Walk
	function startWalk() {
		if (state == Walk)
			return;

		state = Walk;
		animations.play('Walk_Policeman');
	}

	public function new() {
		super();

		iron.Scene.active.notifyOnInit(init);
	}

	function init() {
		head = object.getChildOfType(CameraObject);

		PhysicsWorld.active.notifyOnPreUpdate(preUpdate);
		notifyOnUpdate(update);
		notifyOnRemove(removed);

		aimNode = object.getChild("Aim");
		initAimLoc = aimNode.transform.loc;
		armature = object.getChild("Policeman");
		animations = findAnimation(armature);
		startIdle();
	}

	var xVec = Vec4.xAxis();
	var zVec = Vec4.zAxis();

	function preUpdate() {
		if (Input.occupied || !body.ready)
			return;

		var mouse = Input.getMouse();
		var kb = Input.getKeyboard();

		if (mouse.started() && !mouse.locked)
			mouse.lock();
		else if (kb.started("escape") && mouse.locked)
			mouse.unlock();

		if (mouse.moved) {
			var d = -mouse.movementY / 450;			
			aimNode.transform.translate(0, 0, d);			
						
			var thr = 0.01;
			if (aimNode.transform.loc.z <= initAimLoc.z - thr)
			 	aimNode.transform.loc.z = initAimLoc.z - thr;

			if (aimNode.transform.loc.z >= initAimLoc.z + thr)
				aimNode.transform.loc.z = initAimLoc.z + thr;
		}

		if (mouse.locked || mouse.down()) {
			head.transform.rotate(xVec, -mouse.movementY / 250 * rotationSpeed);
			transform.rotate(zVec, -mouse.movementX / 250 * rotationSpeed);
			body.syncTransform();
		}
	}

	function removed() {
		PhysicsWorld.active.removePreUpdate(preUpdate);
	}

	var dir = new Vec4();

	function update() {
		if (!body.ready)
			return;

		// Move
		dir.set(0, 0, 0);
		if (moveForward)
			dir.add(transform.look());
		if (moveBackward)
			dir.add(transform.look().mult(-1));
		if (moveLeft)
			dir.add(transform.right().mult(-1));
		if (moveRight)
			dir.add(transform.right());

		// Push down
		var btvec = body.getLinearVelocity();
		body.setLinearVelocity(0.0, 0.0, btvec.z - 1.0);

		if (moveForward || moveBackward || moveLeft || moveRight) {
			var dirN = dir.normalize();
			dirN.mult(speed);
			body.activate();
			body.setLinearVelocity(dirN.x, dirN.y, btvec.z - 1.0);
			startWalk();
		} else {
			startIdle();
		}

		// Keep vertical
		body.setAngularFactor(0, 0, 0);
		camera.buildMatrix();
	}
}
