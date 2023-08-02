package arm;

import armory.ui.Canvas;
import zui.Zui;
import iron.Scene;
import armory.trait.internal.CanvasScript;

// Логика работы UI
class GameCanvasLogic extends iron.Trait {
	// UI
	var canvas:CanvasScript;

	public function new() {
		super();

		notifyOnInit(function() {
			canvas = Scene.active.getTrait(CanvasScript);
		});

		// notifyOnUpdate(function() {
		// });

		// notifyOnRemove(function() {
		// });
	}

	// Отображает текст взаимодейтсвия с объектом
	public function showObjectAction() {
		canvas.getElement("ActionText").visible = true;
	}

	// Скрывает текст взаимодейтсвия с объектом
	public function hideObjectAction() {
		canvas.getElement("ActionText").visible = false;
	}

	// Устанавливает количество патронов
	public function setAmmoCount(val:Int) {
		canvas.getElement("PistolAmmoCount").text = '${val} / 15';
	}
}
