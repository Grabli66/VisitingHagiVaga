// Auto-generated
package ;
class Main {
    public static inline var projectName = 'Game';
    public static inline var projectVersion = '1.0.24';
    public static inline var projectPackage = 'arm';
    public static function main() {
        iron.object.BoneAnimation.skinMaxBones = 65;
        armory.system.Starter.numAssets = 529;
        armory.system.Starter.drawLoading = armory.trait.internal.LoadingScreen.render;armory.ui.Canvas.imageScaleQuality = kha.graphics2.ImageScaleQuality.Low;
        armory.system.Starter.main(
            'MenuScene',
            0,
            false,
            true,
            false,
            1920,
            1080,
            1,
            true,
            armory.renderpath.RenderPathCreator.get
        );
    }
}
