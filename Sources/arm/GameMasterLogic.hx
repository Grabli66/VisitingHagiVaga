package arm;

import iron.object.BoneAnimation;
import common.TickTimer;
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
	// Время перед возрождением монстра
	var respawnTimeSec = 6;

	var respawnTimer:TickTimer;

	// Добавляет обработчики событий
	function addEventHandlers() {		
		Event.add('huggy_dead', () -> {
			var deadPos = Scene.global.properties['huggy_dead_pos'];
			spawnRandomItemAtPos(deadPos);

			respawnTimer.enabled = true;
		});
	}

	// Ищет анимации
	function findAnimation(o:Object):BoneAnimation {
		if (o == null)
			return null;

		if (o.animation != null)
			return cast o.animation;
		for (c in o.children) {
			var co = findAnimation(c);
			if (co != null)
				return co;
		}
		return null;
	}

	// Создаёт монстра
	function spawnMonster() {
		var level = Random.getIn(0,2);
		var name = switch level {
			case 0:
				'ПодвалВ';
			case 1:
				'Этаж1В';
			case 2:
				'Этаж2В';
			default:
				'ПодвалВ';
		}

		var col = Scene.active.getGroup(name);					
		var ind = Random.getIn(0, col.length - 1);
		var spawnObject = col[ind];

		Data.getSceneRaw("SpawnScene", function(raw:TSceneFormat) {
			Scene.active.spawnObject('Monster', null, function(o:Object) {
				o.transform.loc.setFrom(spawnObject.transform.loc);
				o.transform.buildMatrix();
				var trait = new HuggyLogic();
				trait.playerObject = Scene.active.getChild('Игрок');
				o.addTrait(trait);
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

			respawnTimer = new TickTimer(respawnTimeSec, () -> {
				respawnTimer.enabled = false;
				spawnMonster();
			});
		});

		notifyOnUpdate(function() {
			respawnTimer.update();
		});
	}
}
