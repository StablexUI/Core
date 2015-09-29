package sx.input;

import sx.widgets.Widget;



/**
 * Manages pointers events (like mouse and touch)
 *
 */
class PointerManager
{
    /** Manager instance */
    static private var __instance : PointerManager;


    /**
     * Should be called by backend when user pressed mouse button or started touch interaction.
     */
    static public function pressed (widget:Null<Widget>) : Void
    {

    }


    /**
     * Should be called by backend when user released mouse button or ended touch.
     */
    static public function release (widget:Null<Widget>) : Void
    {

    }


    /**
     * Should be called by backend when user moved pointer.
     */
    static public function moved (widget:Null<Widget>) : Void
    {

    }


    /**
     * Constructor
     */
    private function new () : Void
    {

    }

}//class PointerManager