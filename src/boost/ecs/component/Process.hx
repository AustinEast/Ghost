package boost.ecs.component;

import boost.util.DataUtil;
import ecs.component.Component;

class Process extends Component {
    /**
	 * Default Process Options
	 */
	public static var defaults(get, null): ProcessOptions;
    /**
     * The Task to be Processed
     */
    public var task:Void->Void;
    /**
     * Flag to set whether this Process will remain active between Processor loops
     */
    public var loop:Bool;
    /**
     * Flag to set whether the Task will be processed in the current Processor loop
     */
    public var active:Bool;

    public function new (task:Void->Void, ?options:ProcessOptions) {
        options = DataUtil.copy_fields(options, defaults);
        this.task = task;
        loop = options.loop;
        active = options.active;
    }

    static function get_defaults():ProcessOptions return {
        loop: true,
        active: true
    }
}

typedef ProcessOptions = {
	?loop:Bool,
    ?active:Bool
}