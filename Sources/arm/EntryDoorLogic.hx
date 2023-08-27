package arm;

import armory.system.Event;
import common.ObjectWithActionTrait;

// Состояние
enum EntryDoorLogicState {
	// Нужен ключ
	NeedKey;

	// У игрока есть ключ
	HaveKey;
}

// Логика входной двери
class EntryDoorLogic extends ObjectWithActionTrait {
	// Состояние
	var state = EntryDoorLogicState.NeedKey;

	// Конструктор
	public function new() {
		super();

		notifyOnInit(function() {
			Event.add('pick_key', () -> {
				state = HaveKey;
			});
		});
	}

	// Запускает
	public override function start() {
		if (state == HaveKey) {
			state = NeedKey;		
			Event.send('use_key');
		}
	}

	// Возвращает текст взаимодействия
	public override function getActionText():String {
		return switch state {
			case NeedKey:
				'Нужен ключ';
			case HaveKey:
				'[E] Использовать ключ';
		}		
	}
}
