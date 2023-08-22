package common;

// Таймер
class TickTimer {
	// Интервал в секундах
	var intervalSec:Float;

	// Вызов на таймер
	var onTimer:Void->Void;

	// Дельта
	var delta:Float;

	var _enabled:Bool = false;

	function set_enabled(v:Bool):Bool {
		_enabled = v;
		if (!_enabled) {
			delta = 0;
		}
		return v;
	}

	function get_enabled():Bool {
		return _enabled;
	}

	// Признак что таймер работает
	public var enabled(get, set):Bool;

	// Конструктор
	public function new(intervalSec:Float, onTimer:Void->Void) {
		this.intervalSec = intervalSec;
		this.onTimer = onTimer;
	}

	// Обновляет
	public function update() {
		if (!enabled)
			return;

		delta += iron.system.Time.delta;
		if (delta >= intervalSec) {
			delta = 0;
			onTimer();
		}
	}

	// Сбрасывает таймер
	public function reset() {
		delta = 0;
	}
}
