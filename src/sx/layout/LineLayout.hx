package sx.layout;


import sx.properties.VerticalAlign;
import sx.properties.HorizontalAlign;
import sx.properties.metric.Units;
import sx.properties.Side;
import sx.layout.Layout;
import sx.properties.Align;
import sx.properties.AutoSize;
import sx.properties.metric.Padding;
import sx.properties.metric.Size;
import sx.widgets.Widget;
import sx.properties.Orientation;

using sx.tools.WidgetTools;
using sx.tools.PropertiesTools;


/**
 * Aligns children horizontally or vertically
 *
 */
class LineLayout extends Layout
{

    /** Padding between container borders and items in that container */
    public var padding (default,null) : Padding;
    /** Distance between items in container */
    public var gap (default,null) : Size;
    /** Align elements horizontally or vertically */
    public var orientation : Orientation;
    /** Set widget size depending on content size */
    public var autoSize (default,null) : AutoSize;
    /** Align children horizontally and vertically. By default: Left,Top */
    public var align (default,null) : Align;

    /** If layout is currently changing widget size */
    private var __adjustingSize : Bool = false;


    /**
     * Constructor
     */
    public function new (orientation = Horizontal) : Void
    {
        super();

        this.orientation = orientation;

        autoSize = new AutoSize();
        align = new Align();
        align.horizontal = Left;
        align.vertical   = Top;

        padding = new Padding();
        padding.ownerWidth  = __widthProvider;
        padding.ownerHeight = __heightProvider;

        gap = new Size();
        gap.pctSource  = __gapPctProvider;
    }


    /**
     * Arrange children according to layout settings
     */
    override public function arrangeChildren () : Void
    {
        if (__widget == null) {
            super.arrangeChildren();
            return;
        }

        __adjustSize();

        switch (orientation) {
            case Horizontal :
                switch (align.horizontal) {
                    case Left   : __arrangeAlongOrientationForward(padding.left.px, Left);
                    case Right  : __arrangeAlongOrientationBackward(padding.right.px, Right);
                    case Center : __arrangeAlongOrientationMiddle();
                    case None   :
                }
                switch (align.vertical) {
                    case Top    : __arrangeCrossOrientation(padding.top.px, Top);
                    case Bottom : __arrangeCrossOrientation(padding.bottom.px, Bottom);
                    case Middle : __arrangeCrossOrientationMiddle();
                    case None   :
                }

            case Vertical :
                switch (align.horizontal) {
                    case Left   : __arrangeCrossOrientation(padding.left.px, Left);
                    case Right  : __arrangeCrossOrientation(padding.right.px, Right);
                    case Center : __arrangeCrossOrientationMiddle();
                    case None   :
                }
                switch (align.vertical) {
                    case Top    : __arrangeAlongOrientationForward(padding.top.px, Top);
                    case Bottom : __arrangeAlongOrientationBackward(padding.bottom.px, Bottom);
                    case Middle : __arrangeAlongOrientationMiddle();
                    case None   :
                }
        }

        super.arrangeChildren();
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
     * Provides `height` or `width` for `gap` percentage calculations
     */
    private function __gapPctProvider () : Size
    {
        if (__widget == null) return Size.zeroProperty;

        return switch (orientation) {
            case Horizontal : __widget.width;
            case Vertical   : __widget.height;
        }
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
            if (this.orientation == orientation) {
                size += (__widget.numChildren - 1) * gap.px;
                for (i in 0...__widget.numChildren) {
                    size += __widget.getChildAt(i).size(orientation).px;
                }

            } else {
                var child;
                var sizeInst;
                for (i in 0...__widget.numChildren) {
                    child = __widget.getChildAt(i);
                    sizeInst = child.size(orientation);
                    if (size < sizeInst.px) size = sizeInst.px;
                }
            }
        }

        return size + padding.sum(orientation);
    }


    /**
     * Arrange children along layout orientation aligning them to `side`, when `side` is `Left` or `Top`
     *
     * @param px    Coordinate for the first child
     */
    private inline function __arrangeAlongOrientationForward (px:Float, side:Side) : Void
    {
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
     * Arrange children along layout orientation aligning them to `side`, when `side` is `Right` or `Bottom`
     *
     * @param px    Coordinate for the first child
     */
    private inline function __arrangeAlongOrientationBackward (px:Float, side:Side) : Void
    {
        var child;
        var coordinate;
        for (i in -(__widget.numChildren - 1)...1) {
            child = __widget.getChildAt(-i);
            coordinate = child.coordinate(side);

            coordinate.px = px;

            px += gap.px + child.size(coordinate.orientation).px;
        }
    }


    /**
     * Arrange children in direction which is perpendicular to layout orientation aligning them to `side`
     *
     * @param px    Coordinate for children
     */
    private inline function __arrangeCrossOrientation (px:Float, side:Side) : Void
    {
        for (i in 0...__widget.numChildren) {
            __widget.getChildAt(i).coordinate(side).px = px;
        }
    }


    /**
     * Description
     */
    private inline function __arrangeAlongOrientationMiddle () : Void
    {
        var px = 0.5 * (__widget.size(orientation).px - __contentSizePx(orientation));

        var side = switch (orientation) {
            case Horizontal : Left;
            case Vertical   : Top;
        }

        __arrangeAlongOrientationForward(px, side);
    }


    /**
     * Description
     */
    private inline function __arrangeCrossOrientationMiddle () : Void
    {
        var orientation = orientation.opposite();
        var middle = 0.5 * __widget.size(orientation).px;
        var side = switch (orientation) {
            case Horizontal : Left;
            case Vertical   : Top;
        }

        var child;
        for (i in 0...__widget.numChildren) {
            child = __widget.getChildAt(i);
            child.coordinate(side).px = middle - child.size(orientation).px * 0.5;
        }
    }


    /**
     * Change widget size according to `autoSize` settings
     */
    private inline function __adjustSize () : Void
    {
        __adjustingSize = true;
        if (autoSize.width)  __widget.width.px  = __contentSizePx(Horizontal);
        if (autoSize.height) __widget.height.px = __contentSizePx(Vertical);
        __adjustingSize = false;
    }


    /**
     * Called when `width` or `height` is changed.
     */
    override private function __widgetResized (widget:Widget, changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (!__adjustingSize) {
            if (changed.isHorizontal()) {
                autoSize.width = false;
            } else {
                autoSize.height = false;
            }

            arrangeChildren();
        }
    }


}//class LineLayout