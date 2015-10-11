package sx.layout;

import sx.widgets.Widget;
import sx.properties.metric.Units;
import sx.properties.metric.Size;



/**
 * Base class for layouts.
 *
 * Layouts arrange children of a widget.
 * Children arranged after adding or removing a child, resizing or initializing widget.
 * Layouts don't arrange children for not initialized widgets.
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
    @:allow(sx.widgets.Widget)
    private function usedBy (widget:Widget) : Void
    {
        if (__widget != null) __widget.layout = null;
        __widget = widget;

        __hookWidget(widget);
        if (widget.initialized) {
            arrangeChildren();
        } else {
            widget.onInitialize.add(__widgetInitialized);
        }
    }


    /**
     * If this layout is no longer in use by current widget
     */
    @:allow(sx.widgets.Widget)
    private function removed () : Void
    {
        if (__widget != null) {
            __releaseWidget(__widget);
            __widget = null;
        }
    }


    /**
     * Listen for widget signals
     */
    private inline function __hookWidget (widget:Widget) : Void
    {
        __widget.onResize.add(__widgetResized);
        __widget.onChildAdded.add(__childAdded);
        __widget.onChildRemoved.add(__childRemoved);
    }


    /**
     * Remove signal listeners
     */
    private inline function __releaseWidget (widget:Widget) : Void
    {
        if (!widget.initialized) {
            widget.onInitialize.remove(__widgetInitialized);
        }

        widget.onResize.remove(__widgetResized);
        widget.onChildAdded.remove(__childAdded);
        widget.onChildRemoved.remove(__childRemoved);
    }


    /**
     * Start listening widget signals after widget was initialized
     */
    private function __widgetInitialized (widget:Widget) : Void
    {
        widget.onInitialize.remove(__widgetInitialized);
        if (__widget == widget) {
            arrangeChildren();
        }
    }


    /**
     * Called when new child added to layout owner
     */
    private function __childAdded (parent:Widget, child:Widget, index:Int) : Void
    {
        if (__widget.initialized) arrangeChildren();
    }


    /**
     * Called when child removed from layout owner
     */
    private function __childRemoved (parent:Widget, child:Widget, index:Int) : Void
    {
        if (__widget.initialized) arrangeChildren();
    }


    /**
     * Called when `width` or `height` is changed.
     */
    private function __widgetResized (widget:Widget, changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (__widget.initialized) arrangeChildren();
    }

}//class Layout
