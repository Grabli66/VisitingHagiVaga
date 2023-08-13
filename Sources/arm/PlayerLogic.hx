package arm;

import armory.trait.physics.bullet.RigidBody;
import kha.math.Random;
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

	// Нода триггер для взаимодействия с предметами
	var grabTrigger:RigidBody;

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

	// Максимальное количество патрон
	public static inline var maxAmmo = 15;

	// Максимальное количество жизней
	public static inline var maxHealth = 3;

	// Текущее количество патрон
	var currentAmmo = maxAmmo;

	// Текущее количество жизни
	var currentHealth = maxHealth;

	// Количество убийств Хагги
	var currentHuggyKill = 0;

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

		contactObject = null;

		var contacts = physics.getContacts(grabTrigger);		
		if (contacts != null && contacts.length > 0) {
			for (body in contacts) {
				var actionTrait = body.object.traits;
				if (actionTrait != null) {
					for (t in actionTrait) {
						if (t is ObjectWithActionTrait) {
							contactObject = cast t;
							break;
						}
					}
				}
			}
		}

		if (contactObject != null) {
			var text = contactObject.getActionText();
			canvas.setObjectActionText(text);
			canvas.showObjectAction();

			var kb = Input.getKeyboard();
			if (kb.started(Keyboard.keyCode(KeyCode.E))) {
				contactObject.start();
			}
		} else {
			canvas.hideObjectAction();
		}
	}

	// Обрабатывает перезарядку
	function processReload() {		
		var kb = Input.getKeyboard();

		if (currentAmmo < 1 && contactObject == null) {
			canvas.setObjectActionText('[R] Перезарядить');
			canvas.showObjectAction();
		}

		// Обрабатывает перезарядку
		if (kb.started(Keyboard.keyCode(KeyCode.R))) {
			startReload();
		}
	}

	// Запускает перезарядку
	function startReload() {		
		if (currentAmmo == maxAmmo)
			return;

		if (currentAmmoPack < 1)
			return;

		if (state == Reload)
			return;

		state = Reload;

		Tween.to({
			target: this,
			props: {fromValue: 1.0},
			duration: 0.4,
			tick: () -> {
				aimNode.transform.translate(0.0, 0.0, -0.02);
			},
			done: () -> {
				Tween.to({
					target: this,
					props: {fromValue: 1.0},
					duration: 0.4,
					tick: () -> {
						aimNode.transform.translate(0.0, 0.0, 0.02);
					},
					done: () -> {
						currentAmmoPack -= 1;
						currentAmmo = maxAmmo;
						canvas.setAmmoCount(currentAmmo);
						canvas.setAmmoPackCount(currentAmmoPack);
						startIdle();
					}
				});
			}
		});
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
		if (currentAmmo < 1)
			return;

		if (shootingAnimData.isFiring)
			return;

		shootingAnimData.isFiring = true;

		// Обновляет количество патрон
		currentAmmo -= 1;
		if (currentAmmo < 0)
			currentAmmo = 0;

		canvas.setAmmoCount(currentAmmo);		

		// Кидает луч для определения попадания
		var physics = PhysicsWorld.active;

		var from = aimNode.transform.world.getLoc();
		var to = aimTargetNode.transform.world.getLoc();

		// Группа коллизии
		var group = 3;
		// Маска коллизии
		var mask = 2;

		var hit = physics.rayCast(from, to, group, mask);
		var rb = (hit != null) ? hit.rb : null;
		if (rb != null)
			trace(rb.object.name);

		if (rb != null && rb.object.name == 'Physics') {
			var parent = rb.object.parent;
			if (parent.name == "Монстр") {
				parent.properties['is_hit'] = true;
			}
		}

		// Эмулирует отдачу от выстрела
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
		animations.play('Die', () -> {			
			var mouse = Input.getMouse();
			mouse.unlock();
			canvas.showGameOver();
		}, 0.2, 1.0, false);
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

		Event.add('pick_medkit', () -> {
			if (currentHealth >= maxHealth)
				return;
			
			currentHealth += 1;
			canvas.setHealth(currentHealth);
		});

		Event.add('huggy_dead', () -> {
			currentHuggyKill += 1;
			canvas.setHuggyKill(currentHuggyKill);
		});

		Event.add('restart_game', () -> {
			iron.Scene.setActive('GameScene', function(o:iron.object.Object) {});
		});
	}

	// Конструктор
	public function new() {
		super();

		iron.Scene.active.notifyOnInit(init);
	}

	// Инициализирует
	function init() {
		Random.init(Date.now().getUTCSeconds());

		object.properties = new Map<String, Dynamic>();

		canvas = Scene.active.getTrait(GameCanvasLogic);
		head = object.getChildOfType(CameraObject);

		PhysicsWorld.active.notifyOnPreUpdate(preUpdate);
		notifyOnUpdate(update);
		notifyOnRemove(removed);

		aimNode = object.getChild("Aim");
		grabTrigger = object.getChild('ХвататьТриггер').getTrait(RigidBody);

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

		// Признак что мышка захвачена
		var mouseLocked = mouse.locked;

		if (mouse.started() && !mouse.locked)
			mouse.lock();
		else if (kb.started("escape") && mouse.locked)
			mouse.unlock();

		if (!mouse.locked)
			return;

		// Если игрок помер
		if (state == Dead || state == Reload)
			return;

		// Обрабатывает действие
		processActionWithObject();

		// Обрабатывает перезарядку
		processReload();

		// Обрабатывает прицеливание
		if (mouse.moved) {
			var d = -mouse.movementY / 250;
			aimNode.transform.translate(0, 0, d);
		}

		// Обрабатывает выстрел
		if (mouse.started() && mouseLocked) {
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
		if (state == Dead || state == Reload)
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
