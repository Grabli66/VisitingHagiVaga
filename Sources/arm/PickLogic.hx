package arm;

import iron.object.Object;
import armory.system.Event;
import common.ObjectWithActionTrait;

// Логика подбора предмета
class PickLogic extends ObjectWithActionTrait {
	// Объект который нужно удалить при взятии
	@prop
	public var removeObject:Object;

	// Конструктор
	public function new() {
		super();

		// notifyOnInit(function() {
		// });

		// notifyOnUpdate(function() {
		// });

		// notifyOnRemove(function() {
		// });
	}

	// Запускает действие
	public override function start() {
		Event.send('pick_ammo');
		if (removeObject != null) {
			removeObject.remove();
		} else {
			object.remove();
		}
	}

	// Возвращает текст взаимодействия
	public override function getActionText():String {
		return '[E] Подобрать';
	}
}
