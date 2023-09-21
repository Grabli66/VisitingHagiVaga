package arm;

import common.TickTimer;
import iron.Scene;
import armory.trait.physics.RigidBody;
import armory.system.Event;
import iron.object.BoneAnimation;
import armory.trait.NavAgent;
import iron.math.Vec4;
import armory.trait.navigation.Navigation;
import iron.object.Object;
import armory.trait.physics.PhysicsWorld;

// Состояние работы логики Хаги
enum HuggyState {
	// Отсутствует
	None;

	// Идёт
	Walk;
	// Атакует
	Attack;
	// Получает повреждение от игрока
	Hit;
	// Помирает
	Dead;
}

// Логика Хагги
class HuggyLogic extends iron.Trait {
	// Интервал таймера
	static final navTimerInterval = 0.5;

	// Счетчик таймера навигации
	var navTimer:TickTimer;

	// Состояние
	var state = HuggyState.None;

	// Анимации
	var animimations:BoneAnimation;

	// Агент навмеша
	var navAgent:NavAgent;

	// Текущее здоровье
	var currentHealth:Int;

	// Физика монстра
	var monsterBody:RigidBody;

	// Объект игрока
	@prop
	public var playerObject:Object;

	// Скорость движения
	@prop
	public var speed:Float = 1.5;

	// Дистанция до атаки
	@prop
	public var attackDistance = 2.0;

	// Максимальное здоровье
	@prop
	public var maxHealth = 3;

	// Ищет анимации
	function findAnimation(o:Object):BoneAnimation {
		if (o == null)
			return null;

		if (o.animation != null)
			return cast o.animation;
		for (c in o.children) {
			var co = findAnimation(c);
			if (co != null)
				return co;
		}
		return null;
	}

	// Начниает помирать
	function startDead() {
		if (state == Dead)
			return;

		object.getChild('Кулак').getTrait(RigidBody).remove();
		object.getChild('Physics').getTrait(RigidBody).remove();

		navTimer.enabled = false;

		state = Dead;

		navAgent.stop();

		animimations.play("Die_Huggy", () -> {
			object.remove();
		}, 0.2, 1.2, false);

		Scene.global.properties['huggy_dead_pos'] = object.transform.loc;
		Event.send('huggy_dead');
		Scene.global.properties['huggy_dead_pos'] = null;
	}

	// Начинает повреждение
	function startHit() {
		// Убавляет здоровье
		currentHealth -= 1;
		if (currentHealth <= 0) {
			startDead();
			return;
		}

		if (state == Hit)
			return;

		state = Hit;

		navAgent.stop();

		animimations.play("Hit_Huggy", () -> {
			startWalking();
		}, 0.2, 1.8, false);
	}

	// Начинает атаку
	function startAttack() {
		if (state == Attack)
			return;

		state = Attack;

		navAgent.stop();
		animimations.play("Attack_Huggy", () -> {
			startWalking();
		}, 0.2, 1.2);
	}

	// Начинает идти
	function startWalking() {
		if (state == Walk)
			return;

		state = Walk;
		#if kha_html5
		animimations.play("Move_Huggy", 0.2, 0.8);
		#else		
		animimations.play("Move_Huggy", 0.2, 0.6);
		#end
	}

	// Начинает навигацию
	function startNavigate(from:Vec4, to:Vec4) {
		if (state == Attack || state == Hit)
			return;

		// Хаги идёт к игроку
		Navigation.active.navMeshes[0].findPath(from, to, function(path:Array<iron.math.Vec4>) {			
			var agent:NavAgent = object.getTrait(armory.trait.NavAgent);
			agent.speed = speed;
			agent.turnDuration = 0.4;
			agent.heightOffset = 0;
			agent.setPath(path);
		});
	}

	// Проверяет контакт с триггером открытия двери
	function checkOpenDoorTrigger() {
		var physics = PhysicsWorld.active;

		var contacts = physics.getContacts(monsterBody);
		if (contacts.length > 0) {
			for (body in contacts) {
				var actionTrait = body.object.traits;
				if (actionTrait != null) {
					for (t in actionTrait) {
						if (t is DoorOpenTrigger) {
							var contactObject:DoorOpenTrigger = cast t;
							contactObject.trigger();
							break;
						}
					}
				}
			}
		}
	}

	// Обновляет логику
	function update() {
		if (state == Dead)
			return;

		if (object.properties['is_hit']) {
			object.properties['is_hit'] = false;
			startHit();
		}

		if (state == Attack || state == Hit || state == Dead)
			return;

		navTimer.update();
	}

	public function new() {
		super();

		notifyOnInit(function() {
			Event.add('win', () -> {
				startDead();
			});

			object.properties = new Map<String, Dynamic>();
			animimations = findAnimation(object);
			
			navAgent = object.getTrait(NavAgent);
			monsterBody = object.getChild('Physics').getTrait(RigidBody);

			currentHealth = maxHealth;			

			// Таймер навигации
			navTimer = new TickTimer(navTimerInterval, () -> {				
				var from = object.transform.world.getLoc();
				var to = playerObject.transform.world.getLoc();

				var distance = Vec4.distance(from, to);
				if (distance <= attackDistance) {
					// Хаги приблизился к игроку
					startAttack();
				} else {
					startNavigate(from, to);
					checkOpenDoorTrigger();
				}
			});
			navTimer.enabled = true;

			startWalking();
		});

		notifyOnUpdate(function() {
			update();
		});
	}
}
