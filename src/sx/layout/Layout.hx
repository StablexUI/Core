package sx.layout;

import sx.properties.metric.Padding;
import sx.properties.metric.Size;
import sx.properties.Orientation;
import sx.widgets.Widget;
import sx.properties.AutoSize;



/**
 * Base class for layouts
 *
 */
class Layout
{
    /** Padding between container borders and items in that container */
    public var padding (default,null) : Padding;
    /** Set widget size depending on content size */
    public var autoSize (default,null) : AutoSize;

    /** Widget this layout is assigned to */
    private var __widget : Widget;


    /**
     * Constructor
     */
    public function new () : Void
    {
        // autoSize = new AutoSize();
        // autoSize.onChange.add(__autoSizeChanged);

        // padding = new Padding();
        // padding.ownerWidth  = __widthProvider;
        // padding.ownerHeight = __heightProvider;
        // padding.onChange.add(__paddingChanged);
    }


    /**
     * Arrange children according to layout settings
     */
    public function arrangeChildren () : Void
    {
        // if (autoSize.)
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


    /**
     * Called when `autoSize` settings changed
     */
    private function __autoSizeChanged (widthChanged:Bool, heightChanged:Bool) : Void
    {

    }


    /**
     * Called when `padding` settings changed
     */
    private function __paddingChanged (horizontalChanged:Bool, verticalChanged:Bool) : Void
    {

    }


    /**
     * Calculate content width or height in pixels.
     *
     * @param horizontal    Calculate content width if `true`, otherwise calculate height.
     */
    private function __contentSizePx (orientation:Orientation) : Float
    {
        var min = 0.;
        var max = 0.;

        var child : Widget;
        for (i in 0...__widget.numChildren) {
            child = __widget.getChildAt(i);

            switch (orientation) {
                case Horizontal:
                    if (i == 0 || child.left.px < min) min = child.left.px;
                    if (i == 0 || child.right.px > max) max = child.right.px;
                case Vertical:
                    if (i == 0 || child.top.px < min) min = child.top.px;
                    if (i == 0 || child.bottom.px > max) max = child.bottom.px;
            }
        }

        return max - min + padding.sum(orientation);
    }

}//class Layout
