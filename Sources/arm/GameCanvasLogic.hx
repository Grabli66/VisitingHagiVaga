package arm;

import armory.ui.Canvas;
import zui.Zui;
import iron.Scene;
import armory.trait.internal.CanvasScript;

// Логика работы UI
class GameCanvasLogic extends iron.Trait {
	// UI
	var canvas:CanvasScript;	

	var isCanvasReady = false;

	public function new() {
		super();

		notifyOnInit(function() {
			canvas = Scene.active.getTrait(CanvasScript);
			isCanvasReady = true;

			var player = Scene.active.getChild('Игрок').getTrait(PlayerLogic);

			//setAmmoPackCount(player.currentAmmoPack);
		 	//setAmmoCount(player.currentAmmo);
		 	//setHealth(player.currentHealth);
		});	
	}

	// Признак что логика готова
	public function isReady() {
		return isCanvasReady;
	}

	// Устанавливает здоровье
	public function setHealth(val : Int) {
		var full = 'heart-full.png';
		var empty = 'heart-empty.png';

		if (val > 0) {
			canvas.getElement("Heart1").asset = full;
		} else {
			canvas.getElement("Heart1").asset = empty;
		}

		if (val > 1) {
			canvas.getElement("Heart2").asset = full;
		} else {
			canvas.getElement("Heart2").asset = empty;
		}

		if (val > 2) {
			canvas.getElement("Heart3").asset = full;
		} else {
			canvas.getElement("Heart3").asset = empty;
		}
	}

	// Устанавливает что ключ подобран
	public function setKey() {
		canvas.getElement("KeyImage").visible = true;
	}

	// Удаляет ключ
	public function removeKey() {
		canvas.getElement("KeyImage").visible = false;
	}

	// Отображает текст взаимодейтсвия с объектом
	public function showObjectAction() {
		canvas.getElement("ActionText").visible = true;
	}

	// Скрывает текст взаимодейтсвия с объектом
	public function hideObjectAction() {		
		canvas.getElement("ActionText").visible = false;
	}

	// Устанавливает текст взаимодейтсвия с объектом
	public function setObjectActionText(val : String) {
		canvas.getElement("ActionText").text = val;
	}

	// Устанавливает количество патронов
	public function setAmmoCount(val:Int) {
		canvas.getElement("PistolAmmoCount").text = '${val} / ${PlayerLogic.maxAmmo}';
	}

	// Устанавливает количество коробок патронов
	public function setAmmoPackCount(val:Int) {
		canvas.getElement("AmmoBoxCount").text = '${val}';
	}

	// Устанавливает количество смертей Хагги
	public function setHuggyKill(val:Int) {
		canvas.getElement("HuggyKill").text = '${val}';
	}

	// Отображает Game Over
	public function showGameOver() {
		canvas.getElement('GameOver').visible = true;		
	}

	// Отображает Win
	public function showWin() {
		canvas.getElement('WinImage').visible = true;		
	}
}
