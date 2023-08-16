package common;

// Таймер
class TickTimer {
	// Интервал в мс
	var intervalMs:Float;

	// Вызов на таймер
	var onTimer:Void->Void;

	// Дельта
	var delta:Float;

	// Конструктор
	public function new(intervalMs:Float, onTimer:Void->Void) {
		this.intervalMs = intervalMs;
		this.onTimer = onTimer;
	}

	// Обновляет
	public function update() {
		delta += iron.system.Time.delta;
		if (delta >= intervalMs) {
			delta = 0;
			onTimer();
		}
	}
}
