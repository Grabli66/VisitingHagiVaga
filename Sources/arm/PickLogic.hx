package arm;

import iron.object.Object;
import armory.system.Event;
import common.ObjectWithActionTrait;

// Логика подбора предмета
class PickLogic extends ObjectWithActionTrait {
	// Объект который нужно удалить при взятии
	@prop
	public var removeObject:Object;

	// Событие которое порождается при подбирании
	@prop
	public var pickEvent:String = 'pick_ammo';

	// Конструктор
	public function new() {
		super();
	}

	// Запускает действие
	public override function start() {
		Event.send(pickEvent);
		if (removeObject != null) {
			removeObject.remove();
		} else {
			object.remove();
		}
	}

	// Возвращает текст взаимодействия
	public override function getActionText():String {
		return '[У] Подобрать';
	}
}
