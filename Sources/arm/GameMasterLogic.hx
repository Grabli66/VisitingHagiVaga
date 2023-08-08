package arm;

import armory.trait.physics.RigidBody;
import iron.math.Vec4;
import armory.system.Event;
import kha.math.Random;
import iron.object.Object;
import iron.data.SceneFormat.TSceneFormat;
import iron.data.Data;
import iron.Scene;

// Логика управляющего игрой
class GameMasterLogic extends iron.Trait {
	// Добавляет обработчики событий
	function addEventHandlers() {
		Event.add('huggy_dead', () -> {
			var deadPos = Scene.global.properties['huggy_dead_pos'];
			spawnRandomItemAtPos(deadPos);
		});
	}

	// Создаёт монстра
	function spawnMonster() {
		var col = Scene.active.getGroup('МестаВозрожденияМонстра');
		var ind = Random.getIn(0, col.length - 1);
		var spawnObject = col[ind];

		Data.getSceneRaw("SpawnScene", function(raw:TSceneFormat) {
			Scene.active.spawnObject('Монстр', null, function(o:Object) {
				o.transform.loc.setFrom(spawnObject.transform.loc);
				o.transform.buildMatrix();
			}, true, raw);
		});
	}

	// Возвращает произвольный объект
	function getRandomItemName():String {
		return if (Random.getIn(0, 1) > 0) {
			'ФизикаПатронов';
		} else {
			'ФизикаАптечки';
		}
	}

	// Создаёт произвольную вещь по позиции
	function spawnRandomItemAtPos(pos:Vec4) {
		Data.getSceneRaw("SpawnScene", function(raw:TSceneFormat) {
			var itemName = getRandomItemName();

			Scene.active.spawnObject(itemName, null, function(o:Object) {
				o.transform.loc = o.transform.loc.setFrom(pos);
				o.transform.buildMatrix();
				o.getTrait(RigidBody).syncTransform();				
			}, true, raw);
		});
	}

	// Создаёт произвольную вещь, в произвольном месте
	function spawnRandomItem() {
		var col = Scene.active.getGroup('МестаПоявленияВещей');
		var ind = Random.getIn(0, col.length - 1);
		var spawnObject = col[ind];

		Data.getSceneRaw("SpawnScene", function(raw:TSceneFormat) {
			var itemName = getRandomItemName();

			Scene.active.spawnObject(itemName, spawnObject, function(o:Object) {}, true, raw);
		});
	}

	public function new() {
		super();

		notifyOnInit(function() {
			Scene.global.properties = new Map<String, Dynamic>();

			spawnMonster();
			spawnRandomItem();

			addEventHandlers();
		});

		notifyOnUpdate(function() {});
	}
}
