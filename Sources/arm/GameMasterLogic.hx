package arm;

import iron.object.Object;
import iron.data.SceneFormat.TSceneFormat;
import iron.data.Data;
import iron.Scene;

// Логика управляющего игрой
class GameMasterLogic extends iron.Trait {
	// Создаёт монстра
	function spawnMonster() {
		var spawnObject = Scene.active.getChild('Возрождение2');

		Data.getSceneRaw("SpawnScene", function(raw:TSceneFormat) {			
			Scene.active.spawnObject('Монстр', null, function(o:Object) {
				o.transform.loc.setFrom(spawnObject.transform.loc);
				o.transform.buildMatrix();
			}, true, raw);
		});
	}

	public function new() {
		super();

		notifyOnInit(function() {
			spawnMonster();
		});

		notifyOnUpdate(function() {});

		// notifyOnRemove(function() {
		// });
	}
}
