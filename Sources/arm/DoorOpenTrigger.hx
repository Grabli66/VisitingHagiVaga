package arm;

import iron.object.Object;

// Триггер открывания двери для монстра
class DoorOpenTrigger extends iron.Trait {	
	// Дверь
	@prop
	public var door:Object;
	
	public function new() {
		super();

		notifyOnInit(function() {});

		// notifyOnUpdate(function() {
		// });

		// notifyOnRemove(function() {
		// });
	}

	// Приводит триггер в действие
	public function trigger() {
		if (door == null)
			return;

		var doorLogic = door.getTrait(DoorLogic);
		if (doorLogic == null)
			return;

		if (!doorLogic.isOpen)
			doorLogic.start();
	}
}
