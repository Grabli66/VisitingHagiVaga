package arm;

import iron.math.Vec4;
import armory.trait.physics.bullet.RigidBody;
import iron.object.Object;

// Синхронизирует с родительским объектом
class SyncWithParent extends iron.Trait {
	// Родительский объект
	@prop
	public var parent:Object;
	
	public function new() {
		super();

		notifyOnInit(function() {
		});

		notifyOnUpdate(function() {
			var parentLoc = parent.transform.world.getLoc();			
			object.transform.loc.setFrom(parentLoc);
			object.transform.buildMatrix();
			var body = object.getTrait(RigidBody);
			if (body != null) {
				body.syncTransform();
			}
		});

		// notifyOnRemove(function() {
		// });
	}
}
