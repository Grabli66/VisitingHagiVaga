package arm;

import iron.system.Input;
import iron.object.Object;
import armory.system.Event;
import iron.Scene;
import armory.trait.internal.CanvasScript;
import common.ArmoryHelper;

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
				ArmoryHelper.loadScene('GameScene');
			});
		});

		notifyOnUpdate(function() {
			var canvasScript = Scene.active.getTrait(CanvasScript);
			var canva = canvasScript.getCanvas();
			if (canva != null) {
				if (canva.height > canva.width) {
					canvasScript.setUiScale(canva.width / 1920);
				} else {
					canvasScript.setUiScale(canva.height / 1080);
				}
			}

			if (state == Load) {
				Event.events.clear();
				state = Complete;
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
