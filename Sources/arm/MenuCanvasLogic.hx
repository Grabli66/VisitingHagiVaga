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
	Load;
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
				canvas.getElement('StoryImage').visible = false;
				canvas.getElement('LoadingText').visible = true;
				state = Load;
			});
		});

		notifyOnUpdate(function() {
			var canva = Scene.active.getTrait(CanvasScript);
			if (canva != null) {
				if (canva.getCanvas().height > canva.getCanvas().width) {
					canva.setUiScale(canva.getCanvas().width / 1920);
				} else {
					canva.setUiScale(canva.getCanvas().height / 1080);
				}
			}

			if (state == Load) {
				Event.events.clear();
				state = Complete;
				iron.Scene.setActive('GameScene', function(o:iron.object.Object) {});
				return;
			}

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
