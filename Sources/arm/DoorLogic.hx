package arm;

import common.ObjectWithActionTrait;
import iron.math.Quat;
import iron.system.Tween;
import armory.trait.physics.bullet.RigidBody;

// Логика двери
class DoorLogic extends ObjectWithActionTrait {
	// Угол на который нужно открыть дверь
	static inline var openValue = 0.07;

	// Физическое тело
	var body:RigidBody;

	// Признак что происходит действие
	var inAction:Bool;
	
	var fromValue = new Quat();
	var toValue = new Quat();

	// Признак что открыто
	public var isOpen:Bool;

	public function new() {
		super();

		notifyOnInit(function() {
			body = object.getTrait(RigidBody);
		});
	}

	// Запускает действие
	public override function start() {
		if (inAction)
			return;

		inAction = true;

		toValue = if (isOpen) {
			fromValue = new Quat();
			toValue = toValue.fromEuler(0, 0, -openValue);
		} else {
			fromValue = new Quat();
			toValue = toValue.fromEuler(0, 0, openValue);
		}

		isOpen = !isOpen;

		Tween.to({
			target: this,
			props: {fromValue: toValue},
			duration: 1.0,
			tick: () -> {
				object.transform.rot.mult(fromValue);
				object.transform.buildMatrix();
				body.syncTransform();
			},
			done: () -> {
				inAction = false;
			}
		});
	}

	// Возвращает текст взаимодействия
	public override function getActionText():String {
		return if (isOpen) {
			'[E] Закрыть дверь';
		} else {
			'[E] Открыть дверь';
		}
	}
}
