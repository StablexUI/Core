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
     * Arrange children according to layout settings
     */
    public function arrangeChildren () : Void
    {

    }


    /**
     * Called when this layout is assigned to `widget`.
     */
    public function usedBy (widget:Widget) : Void
    {
        if (__widget != null) __widget.layout = null;

        __widget = widget;

        __widget.onChildAdded.add(__childAdded);
        __widget.onChildRemoved.add(__childRemoved);

        arrangeChildren();
    }


    /**
     * If this layout is no longer in use by current widget
     */
    public function removed () : Void
    {
        if (__widget != null) {
            __widget.onChildAdded.remove(__childAdded);
            __widget.onChildRemoved.remove(__childRemoved);

            __widget = null;
        }
    }


    /**
     * Called when new child added to layout owner
     */
    private function __childAdded (parent:Widget, child:Widget, index:Int) : Void
    {

    }


    /**
     * Called when child removed from layout owner
     */
    private function __childRemoved (parent:Widget, child:Widget, index:Int) : Void
    {

    }


}//class Layout
