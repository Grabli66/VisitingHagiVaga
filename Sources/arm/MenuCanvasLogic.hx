package arm;

import iron.system.Input;
import iron.object.Object;
import armory.system.Event;
import iron.Scene;
import armory.trait.internal.CanvasScript;

// Состояние меню
enum MenuCanvasLogicState {
	Init;
	Start;
	Complete;
}

class MenuCanvasLogic extends iron.Trait {
	// UI
	var canvas:CanvasScript;

	// Состояние
	var state = MenuCanvasLogicState.Init;

	// Конструктор
	public function new() {
		super();

		notifyOnInit(function() {
			canvas = Scene.active.getTrait(CanvasScript);

			Event.add('start_game', () -> {
				canvas.getElement('StartButton').visible = false;

				canvas.getElement('StoryImage').visible = true;
			});

			Event.add('story_next', () -> {
				iron.Scene.setActive('GameScene', function(o:iron.object.Object) {});
			});
		});

		notifyOnUpdate(function() {
			if (state == Complete)
				return;

			var mouse = Input.getMouse();
			if (mouse.started()) {
				switch (state) {
					case Init:
						state = Start;
						Event.send("start_game");
					case Start:
						state = Complete;
						Event.send("story_next");
					default:
				}
			}
		});
	}
}
