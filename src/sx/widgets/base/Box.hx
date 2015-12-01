package sx.widgets.base;

import sx.exceptions.InvalidArgumentException;
import sx.layout.Layout;
import sx.layout.LineLayout;
import sx.properties.abstracts.AAlign;
import sx.properties.abstracts.AAutoSize;
import sx.properties.abstracts.APadding;
import sx.properties.abstracts.ASize;
import sx.properties.Align;
import sx.properties.Orientation;



/**
 * Widget with `sx.layout.LineLayout`.
 *
 * Trying to change layout to another one which is not compatible with LineLayout will throw `sx.exceptions.InvalidArgumentException`.
 */
class Box extends Widget
{
    /** Padding between container borders and items in that container. By default: 0 */
    public var padding (get,set) : APadding;
    /** Distance between items in container. By default: 0 */
    public var gap (get,set) : ASize;
    /** Align elements horizontally or vertically. By default: Vertical */
    public var orientation (get,set) : Orientation;
    /** Set widget size depending on content size. By default: true */
    public var autoSize (get,set) : AAutoSize;
    /** Align children horizontally and vertically. By default: Center & Middle */
    public var align (get,set) : AAlign;

    /** Layout instance */
    private var __lineLayout : LineLayout;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        __lineLayout = new LineLayout(Vertical);
        __lineLayout.autoSize.set(true, true);
        __lineLayout.align.set(Center, Middle);

        layout = __lineLayout;
    }


    /**
     * Arrange children.
     *
     * Children automatically arranged if widget resized or some child was added/removed.
     */
    public function arrangeChildren () : Void
    {
        __lineLayout.arrangeChildren();
    }


    /**
     * Setter `layout`
     */
    override private function set_layout (value:Layout) : Layout
    {
        if (!Std.is(value, LineLayout)) {
            throw new InvalidArgumentException('The only layout Box widget accepts is LineLayout or his descendants.');
        }
        __lineLayout = cast value;

        return super.set_layout(value);
    }


    /** Getters */
    private function get_padding ()         return __lineLayout.padding;
    private function get_gap ()             return __lineLayout.gap;
    private function get_orientation ()     return __lineLayout.orientation;
    private function get_align ()           return __lineLayout.align;
    private function get_autoSize ()        return __lineLayout.autoSize;

    /** Setters */
    private function set_padding (v)         return __lineLayout.padding = v;
    private function set_gap (v)             return __lineLayout.gap = v;
    private function set_orientation (v)     return __lineLayout.orientation = v;
    private function set_align (v)           return __lineLayout.align = v;
    private function set_autoSize (v)        return __lineLayout.autoSize = v;

}//class Box