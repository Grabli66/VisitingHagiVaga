package arm;

import iron.object.BoneAnimation;
import iron.object.Object;
import armory.system.Event;
import iron.Scene;
import armory.trait.internal.CanvasScript;

class MenuCanvasLogic extends iron.Trait {
	// UI
	var canvas:CanvasScript;

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

		// notifyOnUpdate(function() {
		// });

		// notifyOnRemove(function() {
		// });
	}
}
