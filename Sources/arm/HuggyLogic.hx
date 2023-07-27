package arm;

import iron.object.BoneAnimation;
import armory.trait.NavAgent;
import iron.math.Vec4;
import armory.trait.navigation.Navigation;
import iron.object.Object;

// Состояние работы логики Хаги
enum HuggyState {
	// Идёт
	Walking;
	// Атакует
	Attacking;
}

// Логика Хагги
class HuggyLogic extends iron.Trait {
	static final navTimerInterval = 0.5;

	// Счетчик таймера навигации
	var navTimerDuration = 0.0;

	// Объект игрока
	@prop
	var playerObject:Object;

	// Скорость движения
	@prop
	var speed:Float = 1.0;

	// Состояние
	var state = HuggyState.Walking;

	// Анимации
	var animimations:BoneAnimation;

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

	// Обрабатывает завершение анимации
	function onAnimationComplete() {
		if (state == Attacking) {
			startWalking();
		}
	}

	// Начинает атаку
	function startAttack() {
		state = Attacking;
		if (animimations.action != "Attack_Huggy") {
			animimations.play("Attack_Huggy");
		}
	}

	function startWalking() {
		state = Walking;
		if (animimations.action != "Move_Huggy") {
			animimations.play("Move_Huggy");
		}
	}

	// Обновляет навигацию
	function updateNavigation() {
		navTimerDuration -= iron.system.Time.delta;

		if (navTimerDuration <= 0.0) {
			navTimerDuration = navTimerInterval;

			#if arm_navigation
			var from = object.transform.world.getLoc();
			var to = playerObject.transform.world.getLoc();

			var distance = Vec4.distance(from, to);
			if (distance <= 1.5) {
				// Хаги приблизился к игроку
				var agent:NavAgent = object.getTrait(armory.trait.NavAgent);
				agent.stop();
				startAttack();
			} else {
				// Хаги идёт к игроку
				Navigation.active.navMeshes[0].findPath(from, to, function(path:Array<iron.math.Vec4>) {
					var agent:armory.trait.NavAgent = object.getTrait(armory.trait.NavAgent);
					agent.speed = speed;
					agent.turnDuration = 0.4;
					agent.heightOffset = 0;
					agent.setPath(path);
				});
			}
			#end
		}
	}

	public function new() {
		super();

		notifyOnInit(function() {
			navTimerDuration = navTimerInterval;
			var armature = object.getChild("Huggy");
			animimations = findAnimation(armature);
			animimations.onComplete = onAnimationComplete;
			startWalking();
		});

		notifyOnUpdate(function() {
			updateNavigation();
		});

		// notifyOnRemove(function() {
		// });
	}
}
