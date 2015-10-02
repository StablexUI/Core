package sx.layout;

import sx.layout.Layout;
import sx.properties.Align;
import sx.properties.AutoSize;
import sx.properties.metric.Gap;
import sx.properties.metric.Padding;
import sx.properties.metric.Size;
import sx.properties.Orientation;



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
        if (autoSize.width) __adjustWidgetSize(__widget.width);
        if (autoSize.height) __adjustWidgetSize(__widget.height);

        // var x = padding.left.px;
        // var y = padding.top.px;
        // var child;
        // for (i in 0...__widget.numChildren) {
        //     child = __widget.getChildAt(i);
        //     child.left.px = x;
        //     child.top.px  = y;

        //     x += child.
        // }

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
     * Set widget `size` according to corresponding content size
     */
    private inline function __adjustWidgetSize (size:Size) : Void
    {
        var horizontal = size.isHorizontal();

        var px = __widget.numChildren * gap.px;
        if (horizontal) {
            px += padding.left.px + padding.right.px;
        } else {
            px += padding.top.px + padding.bottom.px;
        }

        for (i in 0...numChildren) {
            if (horizontal) {
                px += __widget.getChildAt(i).width.px;
            } else {
                px += __widget.getChildAt(i).height.px;
            }
        }

        size.px = px;
    }

}//class HorizontalLayout