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

}//class HorizontalLayout