package arm;

import iron.object.BoneAnimation;
import iron.object.Object;
import armory.system.Event;
import iron.Scene;
import armory.trait.internal.CanvasScript;

class MenuCanvasLogic extends iron.Trait {
	// UI
	var canvas:CanvasScript;

	// Ищет анимацию
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

	public function new() {
		super();

		notifyOnInit(function() {
			canvas = Scene.active.getTrait(CanvasScript);

			Event.add('start_game', () -> {
				canvas.getElement('StartButton').visible = false;

				canvas.getElement('StoryImage').visible = true;
				canvas.getElement('NextButton').visible = true;
			});

			Event.add('story_next', () -> {
				iron.Scene.setActive('GameScene', function(o:iron.object.Object) {});
			});

			var armature = findAnimation(Scene.active.getChild('HuggyIdle'));
			armature.play('Idle_Huggy', null, 0.2, 0.6, true);
		});

		// notifyOnUpdate(function() {
		// });

		// notifyOnRemove(function() {
		// });
	}
}
