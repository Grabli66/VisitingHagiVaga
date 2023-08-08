package arm;

import armory.system.Event;
import iron.object.BoneAnimation;
import armory.trait.NavAgent;
import iron.math.Vec4;
import armory.trait.navigation.Navigation;
import iron.object.Object;

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
	static final navTimerInterval = 0.5;

	// Счетчик таймера навигации
	var navTimerDuration = 0.0;

	// Состояние
	var state = HuggyState.None;

	// Анимации
	var animimations:BoneAnimation;

	// Агент навмеша
	var navAgent:NavAgent;

	// Текущее здоровье
	var currentHealth:Int;

	// Объект игрока
	@prop
	public var playerObject:Object;

	// Скорость движения
	@prop
	public var speed:Float = 1.0;

	// Дистанция до атаки
	@prop
	public var attackDistance = 2.0;

	// Максимальное здоровье
	@prop
	public var maxHealth = 3;

	// Ищет анимации
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

	// Начниает помирать
	function startDead() {
		if (state == Dead)
			return;

		state = Dead;

		navAgent.stop();

		animimations.play("Die_Huggy", () -> {
			object.remove();
		}, 0.2, 1.0, false);

		Event.send('huggy_dead');
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
		}, 0.2, 1.5, false);
	}

	// Начинает атаку
	function startAttack() {
		if (state == Attack)
			return;

		state = Attack;

		navAgent.stop();
		animimations.play("Attack_Huggy", () -> {
			startWalking();
		});
	}

	// Начинает идти
	function startWalking() {
		if (state == Walk)
			return;

		state = Walk;
		animimations.play("Move_Huggy", 0.2, 0.6);
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

		navTimerDuration -= iron.system.Time.delta;

		if (navTimerDuration <= 0.0) {
			navTimerDuration = navTimerInterval;

			var from = object.transform.world.getLoc();
			var to = playerObject.transform.world.getLoc();

			var distance = Vec4.distance(from, to);
			if (distance <= attackDistance) {
				// Хаги приблизился к игроку
				startAttack();
			} else {
				startNavigate(from, to);
			}
		}
	}

	public function new() {
		super();

		notifyOnInit(function() {
			object.properties = new Map<String, Dynamic>();
			navTimerDuration = navTimerInterval;
			var armature = object.getChild("Huggy");
			animimations = findAnimation(armature);			
			navAgent = object.getTrait(NavAgent);

			currentHealth = maxHealth;

			startWalking();
		});

		notifyOnUpdate(function() {
			update();
		});

		// notifyOnRemove(function() {
		// });
	}
}
