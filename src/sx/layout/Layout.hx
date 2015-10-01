package sx.layout;

import sx.widgets.Widget;




/**
 * Base class for layouts
 *
 */
class Layout
{
    /** Widget this layout is assigned to */
    private var __widget : Widget;


    /**
     * Constructor
     */
    public function new () : Void
    {

    }


    /**
     * Called when this layout is assigned to `widget`.
     */
    public function usedBy (widget:Widget) : Void
    {
        if (__widget != null) __widget.layout = null;

        __widget = widget;
        // __widget.onChildAdded.add(__childAdded);
        // __widget.onChildRemoved.add(__childRemoved);
    }


    /**
     * If this layout is no longer in use by current widget
     */
    public function removed () : Void
    {
        __widget = null;
        // __widget.onChildAdded.add(__childAdded);
        // __widget.onChildRemoved.add(__childRemoved);
    }

}//class Layout