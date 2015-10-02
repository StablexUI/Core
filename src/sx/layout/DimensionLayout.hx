package sx.layout;

import sx.layout.Layout;
import sx.properties.Align;
import sx.properties.AutoSize;
import sx.properties.metric.Gap;
import sx.properties.metric.Padding;
import sx.properties.metric.Size;
import sx.Enums;

using sx.tools.WidgetTools;


/**
 * Aligns children horizontally or vertically
 *
 */
class DimensionLayout extends Layout
{

    /** Padding between container borders and items in that container */
    public var padding (default,null) : Padding;
    /** Distance between items in container */
    public var gap (default,null) : Size;
    /** Align elements horizontally or vertically */
    public var orientaition (get,set) : Orientation;
    private var __orientation : Orientation;
    /** Set widget size depending on content size */
    public var autoSize (default,null) : AutoSize;
    /** Align children horizontally and vertically */
    public var align (default,null) : Align;


    /**
     * Constructor
     */
    public function new (orientaition = Horizontal) : Void
    {
        super();

        __orientation = orientaition;

        autoSize = new AutoSize();
        autoSize.onChange.add(__autoSizeChanged);

        padding = new Padding();
        padding.ownerWidth  = __widthProvider;
        padding.ownerHeight = __heightProvider;
        padding.onChange.add(__paddingChanged);

        gap = new Gap();
        gap.ownerWidth  = __widthProvider;
        gap.ownerHeight = __heightProvider;
        gap.onChange.add(__gapChanged);

        align = new Align();
        align.onChange.add(__alignChanged);
    }


    /**
     * Arrange children according to layout settings
     */
    override public function arrangeChildren () : Void
    {
        if (autoSize.width)  __widget.width.px  = __contentSizePx(Horizontal);
        if (autoSize.height) __widget.height.px = __contentSizePx(Vertical);

        switch (oritentation) {
            case Horizontal :
                // switch (align.horizontal) {
                //     case Left   : __arrangeHorizontalLeft();
                //     case Right  : __arrangeHorizontalRight();
                //     case Center : __arrangeHorizontalCenter();
                //     case HNone  :
                // }
            case Vertical :
        }

        super.arrangeChildren();
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
     * Called when `align` settings changed
     */
    private function __alignChanged (horizontalChanged:Bool, verticalChanged:Bool) : Void
    {

    }


    /**
     * Called when `gap` settings changed
     */
    private function __gapChanged (horizontalChanged:Bool, verticalChanged:Bool) : Void
    {

    }


    /**
     * Provides `width` for percentage calculations
     */
    private function __widthProvider () : Size
    {
        return (__widget == null ? Size.zeroProperty : __widget.width);
    }


    /**
     * Provides `height` for percentage calculations
     */
    private function __heightProvider () : Size
    {
        return (__widget == null ? Size.zeroProperty : __widget.height);
    }


    /**
     * Calculate content width or height in pixels.
     *
     * @param horizontal    Calculate content width if `true`, otherwise calculate height.
     */
    private function __contentSizePx (orientation:Orientation) : Float
    {
        var size = 0.;

        if (__widget.numChildren > 0) {
            if (__orientation == orientation) {
                size += __widget.numChildren * gap.px;
                for (i in 0...__widget.numChildren) {
                    switch (orientation) {
                        case Horizontal : size += __widget.getChildAt(i).width.px;
                        case Vertical   : size += __widget.getChildAt(i).height.px;
                    }
                }

            } else {
                var child;
                for (i in 0...__widget.numChildren) {
                    child = __widget.getChildAt(i);
                    switch (orientation) {
                        case Horizontal :
                            if (size < child.width.px) size = child.width.px;
                        case Vertical :
                            if (size < child.height.px) size = child.height.px;
                    }
                }
            }
        }

        return size + padding.sum(orientation);
    }


    /**
     * Description
     */
    private inline function __arrangeAlongOrientationSide (side:Side) : Void
    {
        var px = padding.side(side).px;

        var child;
        var coordinate;
        for (i in 0...__widget.numChildren) {
            child = __widget.getChildAt(i);
            coordinate = child.coordinate(side);

            coordinate.px = px;

            px += gap.px + child.size(coordinate.orientation).px;
        }
    }


    /**
     * Description
     */
    private inline function __arrangeCrossOrientationSide (side:Side) : Void
    {
        var px = padding.side(side).px;

        for (i in 0...__widget.numChildren) {
            __widget.getChildAt(i).left.px = px;
        }
    }


    /**
     * Description
     */
    private inline function __arrangeHorizontalLeft () : Void
    {
        var px = padding.left.px;

        var child;
        for (i in 0...__widget.numChildren) {
            child = __widget.getChildAt(i);
            child.left.px = px;

            px += gap.px + child.width.px;
        }
    }


    /**
     * Description
     */
    private inline function __arrangeVerticalLeft () : Void
    {
        var px = padding.left.px;

        for (i in 0...__widget.numChildren) {
            __widget.getChildAt(i).left.px = px;
        }
    }


    /**
     * Description
     */
    private inline function __arrangeHorizontalRight () : Void
    {
        var px = padding.right.px;

        var child;
        for (i in 0...__widget.numChildren) {
            child = __widget.getChildAt(i);
            child.right.px = px;

            px += gap.px + child.width.px;
        }
    }


    /**
     * Description
     */
    private inline function __arrangeVerticalRight () : Void
    {
        var px = padding.right.px;

        for (i in 0...__widget.numChildren) {
            __widget.getChildAt(i).right.px = px;
        }
    }

}//class HorizontalLayout