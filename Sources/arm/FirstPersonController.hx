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

class FirstPersonController extends CameraController {

#if (!arm_physics)
	public function new() { super(); }
#else

	var head: Object;
	static inline var rotationSpeed = 2.0;

	var armature:Object;
	var anim:BoneAnimation;
	var q = new Quat();
	var mat = Mat4.identity();
	var angle = 0.0;

	@prop
	public var speed:Float = 4;

	function findAnimation(o:Object):BoneAnimation {
		if (o.animation != null) return cast o.animation;
		for (c in o.children) {
			var co = findAnimation(c);
			if (co != null) return co;
		}
		return null;
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

		// armature = object.getChild("Policeman");
		// anim = findAnimation(armature);
		// anim.notifyOnUpdate(updateBones);
	}

	var xVec = Vec4.xAxis();
	var zVec = Vec4.zAxis();
	function preUpdate() {
		if (Input.occupied || !body.ready) return;

		var mouse = Input.getMouse();
		var kb = Input.getKeyboard();

		if (mouse.started() && !mouse.locked) mouse.lock();
		else if (kb.started("escape") && mouse.locked) mouse.unlock();

		if (mouse.moved) {
			var d = mouse.movementY / 250;
			if (angle + d < 1.25 && angle + d > -1.25) {
				angle += d;
			}
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
		if (!body.ready) return;		

		// Move
		dir.set(0, 0, 0);
		if (moveForward) dir.add(transform.look());
		if (moveBackward) dir.add(transform.look().mult(-1));
		if (moveLeft) dir.add(transform.right().mult(-1));
		if (moveRight) dir.add(transform.right());

		// Push down
		var btvec = body.getLinearVelocity();
		body.setLinearVelocity(0.0, 0.0, btvec.z - 1.0);

		if (moveForward || moveBackward || moveLeft || moveRight) {
			var dirN = dir.normalize();
			dirN.mult(speed);
			body.activate();
			body.setLinearVelocity(dirN.x, dirN.y, btvec.z - 1.0);
		}

		// Keep vertical
		body.setAngularFactor(0, 0, 0);
		camera.buildMatrix();
	}

	function updateBones() {

		// Fetch bone
		var bone1 = anim.getBone("mixamorig:LeftForeArm");
		var bone2 = anim.getBone("mixamorig:RightForeArm");

		// Fetch bone matrix - this is in local bone space for now
		var m1 = anim.getBoneMat(bone1);
		var m2 = anim.getBoneMat(bone2);
		var m1b = anim.getBoneMatBlend(bone1);
		var m2b = anim.getBoneMatBlend(bone2);
		var a1 = anim.getAbsMat(bone1.parent);
		var a2 = anim.getAbsMat(bone2.parent);

		// Rotate hand bones to aim with gun
		// Some raw math follows..
		var tx = m1._30;
		var ty = m1._31;
		var tz = m1._32;
		m1._30 = 0;
		m1._31 = 0;
		m1._32 = 0;
		mat.getInverse(a1);
		q.fromAxisAngle(mat.right(), -angle);
		m1.applyQuat(q);
		m1._30 = tx;
		m1._31 = ty;
		m1._32 = tz;

		var tx = m2._30;
		var ty = m2._31;
		var tz = m2._32;
		m2._30 = 0;
		m2._31 = 0;
		m2._32 = 0;
		mat.getInverse(a2);
		var v = mat.right();
		v.mult(-1);
		// Todo: Do inverse kinematics here, right hand moves unnaturally
		q.fromAxisAngle(v, -1.6);
		// q.fromAxisAngle(v, angle);
		m2.applyQuat(q);
		m2._30 = tx;
		m2._31 = ty;
		m2._32 = tz;

		// Animation blending is in progress, we need to rotate those bones too
		if (m1b != null && m2b != null) {
			var tx = m1b._30;
			var ty = m1b._31;
			var tz = m1b._32;
			m1b._30 = 0;
			m1b._31 = 0;
			m1b._32 = 0;
			mat.getInverse(a1);
			q.fromAxisAngle(mat.right(), -angle);
			m1b.applyQuat(q);
			m1b._30 = tx;
			m1b._31 = ty;
			m1b._32 = tz;

			var tx = m2b._30;
			var ty = m2b._31;
			var tz = m2b._32;
			m2b._30 = 0;
			m2b._31 = 0;
			m2b._32 = 0;
			mat.getInverse(a2);
			var v = mat.right();
			v.mult(-1);
			q.fromAxisAngle(v, -1.6);
			// q.fromAxisAngle(v, angle);
			m2b.applyQuat(q);
			m2b._30 = tx;
			m2b._31 = ty;
			m2b._32 = tz;
		}
	}
#end
}
