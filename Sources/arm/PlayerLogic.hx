package arm;

import kha.math.Random;
import iron.math.Vec3;
import iron.Trait;
import kha.input.KeyCode;
import common.ObjectWithActionTrait;
import iron.Scene;
import armory.system.Event;
import iron.system.Tween;
import iron.object.BoneAnimation;
import iron.math.Vec4;
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

// Данные анимации выстрела
class ShootAnimData {
	// Признак что идёт анимация стрельбы
	public var isFiring:Bool;

	// Нода вспышки
	public var flashNode:Object;

	// Конструктор
	public function new() {}
}

// Логика игрока
class PlayerLogic extends CameraController {
	// Камера
	var head:Object;

	var xVec = Vec4.xAxis();
	var yVec = Vec4.yAxis();
	var zVec = Vec4.zAxis();

	// Скрипт управляющий UI
	var canvas:GameCanvasLogic;

	// Скелет игрока
	var armature:Object;

	// Анимации
	var animations:BoneAnimation;

	// Прицел для IK
	var aimNode:Object;

	// Нода что бы выпускать луч для взаимодействия с объектом
	var grabNode:Object;

	// Объект с которым произошёл контакт
	var contactObject:ObjectWithActionTrait;

	// Цель стрельбы для RayCast
	var aimTargetNode:Object;

	// Состояние
	var state = PlayerState.None;

	// Данные анимации стрельбы
	var shootingAnimData:ShootAnimData;

	// Текущее количество коробок с патронами
	var currentAmmoPack = 2;

	// Текущее количество патрон
	var currentAmmo = 15;

	// Текущее количество жизни
	var currentHealth = 3;

	// Скорость поворота
	@prop
	public var rotationSpeed = 2.0;

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

	// Обрабатывает взаимодействие с объектом
	function processActionWithObject() {
		var physics = PhysicsWorld.active;

		var from = head.transform.world.getLoc();
		var to = grabNode.transform.world.getLoc();

		var hit = physics.rayCast(from, to);
		var rb = (hit != null) ? hit.rb : null;
		// Есть контакт
		if (rb != null && rb.object != null) {
			// Не задан объект контакта
			if (contactObject == null) {
				var actionTrait = rb.object.traits;
				if (actionTrait != null) {
					for (t in actionTrait) {
						if (t is ObjectWithActionTrait) {
							contactObject = cast t;
							var text = contactObject.getActionText();
							canvas.setObjectActionText(text);
							canvas.showObjectAction();
							break;
						}
					}
				}
			}
		} else {
			if (contactObject != null) {
				canvas.hideObjectAction();
				contactObject = null;
			}
		}

		if (contactObject != null) {
			var kb = Input.getKeyboard();
			if (kb.started(Keyboard.keyCode(KeyCode.E))) {
				contactObject.start();
			}
		}
	}

	// Переходит в состояние Idle
	function startIdle() {
		if (state == Idle)
			return;

		state = Idle;
		animations.play('Idle_Policeman', null, 1.0, 0.5);
	}

	// Переходит в состояние Walk
	function startWalk() {
		if (state == Walk)
			return;

		state = Walk;
		animations.play('Walk_Policeman', null, 1.0, 0.5);
	}

	// Производит анимацию стрельбы
	function startShooting() {
		if (shootingAnimData.isFiring)
			return;

		shootingAnimData.isFiring = true;

		// Обновляет количество патрон
		currentAmmo -= 1;
		if (currentAmmo < 0)
			currentAmmo = 0;

		canvas.setAmmoCount(currentAmmo);

		if (currentAmmo < 1)
			return;

		// Кидает луч для определения попадания
		var physics = PhysicsWorld.active;

		var from = aimNode.transform.world.getLoc();
		var to = aimTargetNode.transform.world.getLoc();

		var hit = physics.rayCast(from, to);
		var rb = (hit != null) ? hit.rb : null;
		if (rb != null && rb.object.name == 'Physics') {
			var parent = rb.object.parent;
			if (parent.name == "Монстр") {
				parent.properties['is_hit'] = true;
			}
		}

		Tween.to({
			target: this,
			props: {fromValue: 1.0},
			duration: 0.2,
			tick: () -> {
				aimNode.transform.translate(0.0, -0.01, -0.0);
				aimNode.transform.rotate(yVec, -0.05);
			},
			done: () -> {
				Tween.to({
					target: this,
					props: {fromValue: 1.0},
					duration: 0.2,
					tick: () -> {
						aimNode.transform.rotate(yVec, 0.05);
						aimNode.transform.translate(0.0, 0.01, 0.0);
					},
					done: () -> {
						shootingAnimData.isFiring = false;
					}
				});
			}
		});

		shootingAnimData.flashNode.visible = true;
		Tween.to({
			target: this,
			props: {fromValue: 1.0},
			duration: 0.07,
			done: () -> {
				shootingAnimData.flashNode.visible = false;
			}
		});
	}

	// Начинает помирать
	function startDead() {
		if (state == Dead)
			return;

		state = Dead;
		animations.play('Die', () -> {}, 0.2, 1.0, false);
	}

	// Запускает тряску камеры
	function startShakeCamera() {
		var last = new Vec4().setFrom(head.transform.loc);
		var vec = new Vec4();

		function getRand():Float {
			return Random.getFloatIn(-1, 1) / 30;
		}

		Tween.to({
			target: this,
			props: {fromValue: 1.0},
			duration: 0.5,
			tick: () -> {				
				vec.x = getRand();
				vec.y = getRand();
				vec.z = getRand();
				head.transform.loc.add(vec);
				head.transform.buildMatrix();
			},
			done: () -> {				
				head.transform.loc.setFrom(last);
				head.transform.buildMatrix();				
			}
		});
	}

	// Добавляет обработчики событий
	function addEventListeners() {
		Event.add('pick_ammo', () -> {
			currentAmmoPack += 1;
			canvas.setAmmoPackCount(currentAmmoPack);
		});
	}

	// Конструктор
	public function new() {
		super();

		iron.Scene.active.notifyOnInit(init);
	}

	// Инициализирует
	function init() {
		Random.init(1000);

		object.properties = new Map<String, Dynamic>();

		canvas = Scene.active.getTrait(GameCanvasLogic);
		head = object.getChildOfType(CameraObject);

		PhysicsWorld.active.notifyOnPreUpdate(preUpdate);
		notifyOnUpdate(update);
		notifyOnRemove(removed);

		aimNode = object.getChild("Aim");
		grabNode = object.getChild('Хватать');
		aimTargetNode = object.getChild("Цель");
		armature = object.getChild("Policeman");
		animations = findAnimation(armature);

		shootingAnimData = new ShootAnimData();
		shootingAnimData.flashNode = object.getChild("ВспышкаВыстрела");
		shootingAnimData.flashNode.visible = false;

		addEventListeners();

		startIdle();
	}

	// Обновление физики
	function preUpdate() {
		if (Input.occupied || !body.ready)
			return;

		var mouse = Input.getMouse();
		var kb = Input.getKeyboard();

		if (mouse.started() && !mouse.locked)
			mouse.lock();
		else if (kb.started("escape") && mouse.locked)
			mouse.unlock();

		if (!mouse.locked)
			return;

		// Если игрок помер
		if (state == Dead)
			return;

		// Обрабатывает действие
		processActionWithObject();

		// Обрабатывает прицеливание
		if (mouse.moved) {
			var d = -mouse.movementY / 250;
			aimNode.transform.translate(0, 0, d);
		}

		// Обрабатывает выстрел
		if (mouse.started()) {
			startShooting();
		}

		// Проверяет удар Хаги
		if (object.properties["is_hit"]) {
			object.properties["is_hit"] = false;

			startShakeCamera();

			currentHealth -= 1;
			if (currentHealth >= 0) {
				canvas.setHealth(currentHealth);
			}

			if (currentHealth <= 0) {
				startDead();
			}
		}

		// Обрабатывает поворот игрока
		head.transform.rotate(xVec, -mouse.movementY / 250 * rotationSpeed);
		transform.rotate(zVec, -mouse.movementX / 250 * rotationSpeed);
		body.syncTransform();
	}

	function removed() {
		PhysicsWorld.active.removePreUpdate(preUpdate);
	}

	var dir = new Vec4();

	// Обновляет логику
	function update() {
		if (!body.ready)
			return;

		// Если игрок помер
		if (state == Dead)
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
