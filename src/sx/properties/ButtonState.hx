package sx.properties;

import sx.widgets.Text;
import sx.widgets.Widget;



/**
 * Describes properties which will be applied to button when button state switched.
 *
 * By default all properties are `null`.
 * Once accessed property will bi initialized with some default instance.
 */
class ButtonState
{
    /** Icon */
    public var ico (get,set) : Widget;
    private var __ico : Widget;
    /** Text in button */
    public var text (default,set) : String = null;
    /** Label */
    public var label (get,set) : Text;
    private var __label : Text;

    /** Indicates if this is current state of a button */
    public var active (default,null) : Bool = false;


    /**
     * Constructor
     */
    public function new () : Void
    {

    }


    /**
     * Apply this state to a button
     */
    public function activate () : Void
    {
        active = true;
    }



}//class ButtonState