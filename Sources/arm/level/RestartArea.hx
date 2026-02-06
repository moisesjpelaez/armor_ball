package arm.level;

import arm.autoload.GameEvents;
import armory.trait.physics.RigidBody;

class RestartArea extends iron.Trait {
	var rb: RigidBody;

	public function new() {
		super();

		notifyOnInit(function() {
			rb = object.getTrait(RigidBody);
			rb.notifyOnContact(onContact);
			GameEvents.levelWon.connect(onLevelWon);
		});

		notifyOnRemove(function() {
			GameEvents.levelWon.disconnect(onLevelWon);
		});
	}

	function onContact(body: RigidBody) {
		rb.removeContact(onContact);
		GameEvents.playerDied.emit();
		object.remove();
	}

	function onLevelWon() {
		rb.removeContact(onContact);
		object.remove();
	}
}
