package boost;

import ecs.component.Component;
import ecs.system.System;
import boost.ecs.component.sys.Game.GameOptions;
import boost.ecs.system.sys.StateSystem;
import boost.ecs.system.sys.ScaleSystem;
import ecs.entity.Entity;
import hxd.App;
import boost.util.DestroyUtil;

/**
 * The Game Class bootstraps the creation of a HEAPS game
 * 
 * Once created, this class doesn't need to be interacted with directly
 * Instead, look to the Game Manager (GM) Class for available properties and methods
 */
class Game extends hxd.App implements IDestroyable {
	/**
	 * ECS Engine
	 */
	var ecs:ecs.Engine;
    /**
     * The Game Entity
     */
    var game:Entity;
	/**
	 * Temporary store of options to pass into the Game Component on `init()`
	 */
	var options:GameOptions;
	/**
	 * Temporary store of initial_state to pass into the Game Component on `init()`
	 */
	var initial_state:Class<GameState>;
	/**
	 * Creates a new Game and Initial State
	 * @param initial_state The Initial State the Game will load
	 * @param options Optional Parameters to configure the Game
	 */
	public function new(initial_state:Class<GameState>, filesystem:FileSystemOptions, ?options:GameOptions) {
		super();

		this.initial_state = initial_state;
		this.options = options;

		// Create the ECS Engine and Game Entity
		ecs = new ecs.Engine();
        game = new Entity("Game");

		// Add the initial Systems to the ECS Engine
		ecs.systems.add(new StateSystem());
		ecs.systems.add(new ScaleSystem());

		// Load the FileSystem
		switch(filesystem) {
			case EMBED:
			hxd.Res.initEmbed();
			case LOCAL:
			hxd.Res.initLocal();
			case PAK:
			hxd.Res.initPak();
		}
	}

	@:dox(hide) @:noCompletion
	override public function init () {
		// Add our game components, then add the game entity to the ECS Engine
        game.add(new boost.ecs.component.sys.Game(s2d, s3d, engine, options));
		game.add(new boost.ecs.component.sys.States(initial_state));
		game.add(new boost.ecs.component.sys.Engine(engine));
        ecs.entities.add(game);

		// Init the Game Manager
		GM.init(game);
		
		// Call a resize event for good measure
		onResize();
	}

	@:dox(hide) @:noCompletion
	override public function update(dt:Float) {
		super.update(dt);
		ecs.update(dt);
	}

	@:dox(hide) @:noCompletion
	override public function onResize() {
		super.onResize();
		GM.game.resized = true;
	}

	/**
	 * Adds a `System` to the Game.
	 * Useful for adding custom game-wide functionality that persists between states
	 * @param system `System` to add
	 */
	public function add_system(system:System) ecs.systems.add(system);

	/**
	 * Adds a `Component` to the Game.
	 * Useful for adding custom game-wide functionality that persists between states
	 * @param component 
	 */
	public function add_component(component:Component) game.add(component); 

	public function destroy() {
        ecs.destroy();
		dispose();
	}
}

@:enum 
abstract FileSystemOptions (Int) {
	var EMBED = 0;
	var LOCAL = 1;
	var PAK   = 2;
}