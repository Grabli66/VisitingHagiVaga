package common;

import armory.system.Starter;

class ArmoryHelper {
    // Загружает сцену
    public static function loadScene(name:String) {
        #if arm_loadscreen
        function load(g:kha.graphics2.Graphics) {
            if (iron.Scene.active != null && iron.Scene.active.ready)
                iron.App.removeRender2D(load);
            else {                
                Starter.drawLoading(g, iron.data.Data.assetsLoaded, Starter.numAssets);                
            }
        }
        iron.App.notifyOnRender2D(load);
        #end
        iron.Scene.setActive(name, function(o:iron.object.Object) {});
    }
}