package arm;

import kha.math.Random;
import iron.object.Object;
import iron.data.SceneFormat.TSceneFormat;
import iron.data.Data;
import iron.Scene;

// Логика управляющего игрой
class GameMasterLogic extends iron.Trait {
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

	// Создаёт произвольную вещь, в произвольном месте
	function spawnRandomItem() {
		var col = Scene.active.getGroup('МестаПоявленияВещей');
		var ind = Random.getIn(0, col.length - 1);
		var spawnObject = col[ind];

		Data.getSceneRaw("SpawnScene", function(raw:TSceneFormat) {
			var itemName = if (Random.getIn(0, 1) > 0) {
				'ФизикаПатронов';
			} else {
				'ФизикаАптечки';
			}

			Scene.active.spawnObject(itemName, spawnObject, function(o:Object) {}, true, raw);
		});
	}

	public function new() {
		super();

		notifyOnInit(function() {
			spawnMonster();
			spawnRandomItem();
		});

		notifyOnUpdate(function() {});
	}
}
