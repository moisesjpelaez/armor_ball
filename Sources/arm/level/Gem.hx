package arm.level;

import arm.autoload.GameEvents;
import armory.trait.physics.RigidBody;

class Gem extends iron.Trait {
	var rb: RigidBody;

	public function new() {
		super();

		notifyOnInit(function() {
			rb = object.getTrait(RigidBody);
			rb.notifyOnContact(onContact);
		});
	}

	function onContact(body: RigidBody) {
		rb.removeContact(onContact);
		GameEvents.gemCollected.emit();
		object.remove();
	}
}