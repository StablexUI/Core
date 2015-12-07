package sx.layout;

import sx.widgets.Widget;
import sx.properties.metric.Units;
import sx.properties.metric.Size;

using sx.tools.WidgetTools;


/**
 * Base class for layouts.
 *
 * Layouts arrange children of a widget.
 * Children arranged after adding or removing a child, resizing or initializing widget.
 * Layouts don't arrange children for not initialized widgets.
 */
class Layout
{
    /**
     * Indicates if layout should automatically call `arrangeChildren()` in some cases.
     * Depending on layout implementation those cases can be like adding/removing children, widget resizings etc.
     */
    public var autoArrange : Bool = true;
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
     * Check if `child` should be taken into account when arranging children according to layout settings.
     */
    private function __isChildArrangeable (child:Widget) : Bool
    {
        return child.isArrangeable();
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
        if (autoArrange && __widget == widget) {
            arrangeChildren();
        }
    }


    /**
     * Called when new child added to layout owner
     */
    private function __childAdded (parent:Widget, child:Widget) : Void
    {
        if (autoArrange && __widget.initialized && __isChildArrangeable(child)) {
            arrangeChildren();
        }
    }


    /**
     * Called when child removed from layout owner
     */
    private function __childRemoved (parent:Widget, child:Widget) : Void
    {
        if (autoArrange && __widget.initialized && __isChildArrangeable(child)) {
            arrangeChildren();
        }
    }


    /**
     * Called when `width` or `height` is changed.
     */
    private function __widgetResized (widget:Widget, changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (autoArrange && __widget.initialized) {
            arrangeChildren();
        }
    }

}//class Layout
