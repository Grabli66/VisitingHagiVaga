package common;

// Объект с дейтсвием
class ObjectWithActionTrait extends iron.Trait {
	// Запускает
	public function start() {}

	// Возвращает текст взаимодействия
	public function getActionText():String {
		return '[E] Взаимодействовать';
	}
}
