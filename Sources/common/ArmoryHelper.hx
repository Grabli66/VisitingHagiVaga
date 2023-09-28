package common;

class ArmoryHelper {
	// Рисует прогресс загрузки
	public static function render(g:kha.graphics2.Graphics, assetsLoaded:Int, assetsTotal:Int) {
		g.color = kha.Color.Red;

		if (assetsLoaded > assetsTotal)
			assetsLoaded = assetsTotal;

		var per = assetsLoaded / assetsTotal;		
		g.fillRect(100, iron.App.h() / 2 - 50, (iron.App.w() - 200) * per, 100);
	}

	// Загружает сцену
	public static function loadScene(name:String) {
		function load(g:kha.graphics2.Graphics) {
			render(g, iron.data.Data.assetsLoaded, 532);
		}
		iron.App.notifyOnRender2D(load);
		iron.Scene.setActive(name, function(o:iron.object.Object) {
			iron.App.removeRender2D(load);
		});
	}
}
