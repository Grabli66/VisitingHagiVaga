package arm;

import armory.trait.internal.CanvasScript;
import kha.Image;
import iron.object.MeshObject;
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

// Тип поднимаемой вещи
enum PickUpType {
	// Патроны
	Ammo;
	// Аптечка
	Medkit;
	// Ключ
	Key;
}

// Логика управляющего игрой
class GameMasterLogic extends iron.Trait {
	// Количество ключей для победы
	static inline var keysToWin = 10;

	// Период работы логики появления вещей
	var spawnTimePeriodSec = 10;

	// Время перед возрождением монстра
	var respawnTimeSec = 6;

	// Таймер возрождения монстра после смерти
	var respawnAfterDeathTimer:TickTimer;

	// Время жизни монстра после которого появляется ещё монстр
	var liveIntervalSec = 30;

	// Максимальное количество монстров на сцене
	var maxSpawnedMonster = 3;

	// Таймер возрождения монстра из-за его долгой жизни. Если монстра долго не убивают
	var respawnOnLiveTimer:TickTimer;

	// Таймер логики появления вещей
	var itemSpawnTimer:TickTimer;

	// Логика игрока
	var player:PlayerLogic;

	// Количество монстров
	var spawnedMonster = 0;

	// Количество помещённых патронов
	var spawnedAmmo = 0;

	// Количество помещённых аптечек
	var spawnedHealth = 0;

	// Количество принесённых ключей
	var keyCount = 0;

	// Логика canvas
	var canvas:GameCanvasLogic;

	// Состояние конца игры
	var isEnd = false;

	// Запускает выигрышь
	function startWin() {
		isEnd = true;
		canvas.showWin();
		Event.send('win');
		Event.send('game_over');
	}

	// Устанавливает табличку сообщения с номером
	function setMessageNumber(number:Int) {
		var mesh:MeshObject = cast Scene.active.getChild('Табличка');
		var messageNameImg = 'Message${number}.png';
		iron.data.Data.getImage(messageNameImg, (image:Image) -> {
			mesh.materials[1].contexts[0].textures[0] = image;
		});
	}

	// Добавляет обработчики событий
	function addEventHandlers() {
		Event.add('use_key', () -> {
			keyCount += 1;

			if (keyCount >= keysToWin) {
				startWin();
				return;
			}

			setMessageNumber(keyCount + 1);			
			spawnItemAtRandomPlace(Key);
		});

		Event.add('huggy_dead', () -> {
			var deadPos = Scene.global.properties['huggy_dead_pos'];
			// Случайным образом создаёт вещь
			if (Random.getIn(0, 100) >= 90) {
				spawnRandomItemAtPos(deadPos);
			}

			respawnAfterDeathTimer.enabled = true;

			// Сбрасывает таймер возрождения долгой жизни
			respawnOnLiveTimer.reset();
		});

		Event.add('pick_ammo', () -> {
			spawnedAmmo -= 1;
		});

		Event.add('pick_medkit', () -> {
			spawnedHealth -= 1;
		});

		Event.add('huggy_dead', () -> {
			spawnedMonster -= 1;
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
		var level = Random.getIn(0, 2);
		var name = switch level {
			case 0:
				'ПодвалХ';
			case 1:
				'Этаж1Х';
			case 2:
				'Этаж2Х';
			default:
				'ПодвалХ';
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
				spawnedMonster += 1;
				//trace('Monster spawned');
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

	// Возвращает имя объекта
	function getItemName(item:PickUpType) {
		return switch (item) {
			case Ammo:
				'ФизикаПатронов';
			case Medkit:
				'ФизикаАптечки';
			case Key:
				'ФизикаКлюча';
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

	// Создаёт вещь в произвольном месте
	function spawnItemAtRandomPlace(item:PickUpType) {
		Data.getSceneRaw("SpawnScene", function(raw:TSceneFormat) {
			var spawnObject:Object;
			var itemName = getItemName(item);

			switch item {
				case Ammo:
					spawnObject = getItemRandomSpawnObject();
					spawnedAmmo += 1;
				case Medkit:
					spawnObject = getItemRandomSpawnObject();
					spawnedHealth += 1;
				case Key:
					spawnObject = getKeyRandomSpawnObject();
			}

			Scene.active.spawnObject(itemName, spawnObject, function(o:Object) {
				//trace('${itemName}');
			}, true, raw);
		});
	}

	// Возвращает
	function getItemRandomSpawnObject():Object {
		var level = Random.getIn(0, 2);
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
		return spawnObject;
	}

	// Возвращает объект для появления ключа
	function getKeyRandomSpawnObject():Object {
		var col = Scene.active.getGroup('Ключи');
		var ind = Random.getIn(0, col.length - 1);
		var spawnObject = col[ind];
		return spawnObject;
	}

	// Создаёт произвольную вещь, в произвольном месте
	function spawnRandomItem() {
		var spawnObject = getItemRandomSpawnObject();

		Data.getSceneRaw("SpawnScene", function(raw:TSceneFormat) {
			var itemName = getRandomItemName();

			Scene.active.spawnObject(itemName, spawnObject, function(o:Object) {}, true, raw);
		});
	}

	public function new() {
		super();

		notifyOnInit(function() {
			Scene.global.properties = new Map<String, Dynamic>();

			// Располагает вещи: патроны и аптечку
			spawnItemAtRandomPlace(Ammo);
			spawnItemAtRandomPlace(Medkit);
			spawnItemAtRandomPlace(Key);

			// Располагает монстра
			spawnMonster();

			addEventHandlers();

			respawnAfterDeathTimer = new TickTimer(respawnTimeSec, () -> {
				respawnAfterDeathTimer.enabled = false;
				spawnMonster();
			});

			itemSpawnTimer = new TickTimer(spawnTimePeriodSec, () -> {
				// Если количество патрон меньше 1 то появляются патроны
				if (player.currentAmmoPack < 1 && spawnedAmmo < 2) {
					for (i in 0...spawnedMonster)
						spawnItemAtRandomPlace(Ammo);
				}

				// Если количество патрон меньше 1 то появляются патроны
				if (player.currentHealth < PlayerLogic.maxHealth && spawnedHealth < 2) {
					spawnItemAtRandomPlace(Medkit);
				}
			});
			itemSpawnTimer.enabled = true;

			respawnOnLiveTimer = new TickTimer(liveIntervalSec, () -> {
				if (spawnedMonster < maxSpawnedMonster) {
					spawnMonster();
				}
			});

			respawnOnLiveTimer.enabled = true;

			player = Scene.active.getChild('Игрок').getTrait(PlayerLogic);
			canvas = Scene.active.getTrait(GameCanvasLogic);

			setMessageNumber(1);
		});

		notifyOnUpdate(function() {
			if (isEnd)
				return;

			respawnAfterDeathTimer.update();
			itemSpawnTimer.update();
			respawnOnLiveTimer.update();
		});
	}
}
