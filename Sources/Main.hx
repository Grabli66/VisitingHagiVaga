// Auto-generated
package ;
class Main {
    public static inline var projectName = 'Game';
    public static inline var projectVersion = '1.0.18';
    public static inline var projectPackage = 'arm';
    public static function main() {
        iron.object.BoneAnimation.skinMaxBones = 65;armory.ui.Canvas.imageScaleQuality = kha.graphics2.ImageScaleQuality.High;
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
