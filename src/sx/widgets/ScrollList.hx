package sx.widgets;

import sx.behavior.ScrollBehavior;
import sx.properties.Orientation;
import sx.widgets.base.Box;
import sx.widgets.ListItem;
import sx.widgets.Widget;

using sx.tools.WidgetTools;
using sx.tools.PropertiesTools;


/**
 * Scrollable one-dimensional list of some typical items.
 *
 * :WARNING:
 * Does not work. Not finished.
 */
class ScrollList<T:ListItem<D>> extends Widget
{
    /** Description */
    public var orientation : Orientation = Vertical;
    /**
     * If your backend does not support clipping (`Widget.overflow = false` has no effect), then you can
     * set `scrollList.scaleBorderItems = true` to smoothly scale down border items when they are about to move out of
     * boundaries of the list.
     */
    public var scaleBorderItems : Bool = false;
    /** Data to display in list items */
    public var data (get,set) : Null<Array<D>>;
    private var __data : Array<D>;
    /** If provided this callback will be used to create widgets for items in list */
    public var itemFactory : Null<Void->T>;

    /** Instantiated widgets for items */
    private var __items : Array<T>;
    /** Scrolling implementation */
    private var __scrollBehavior : ScrollBehavior;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        __items = [];
        __scrollBehavior = new ScrollBehavior(this);

        __scrollBehavior.onScroll.add(__scrolled);
    }


    /**
     * Refresh items representation in this list
     */
    public function refresh () : Void
    {
        if (__data != null) {
            var sizeDip = this.size(oritentation).dip;
            var contentSizeDip = 0.0;

            var item : T;
            for (i in 0...__data.length) {
                if (__items.length <= i) {
                    item = __createItemWidget();
                    __items.push(item);
                    addChild(item);
                }

                item = __items[i];
                item.data = __data[i];
                item.dataIndex = i;
                setChildIndex(item, i);

                contentSizeDip += item.size(oritentation).dip;
                if (contentSizeDip >= sizeDip) {
                    break;
                }
            }
        }

        __updateBorderWidgets();
    }


    /**
     * Handle widgets which scrolled out of list bounds
     */
    private function __updateBorderWidgets () : Void
    {
        var child;
        for (i in 0...numChildren) {
            __updateChildIfBorder(getChildAt(i));
        }
    }


    /**
     * Description
     */
    private function __updateChildIfBorder (child:Widget) : Bool
    {

    }


    /**
     * User wants to scroll content by `dX` and `dY`
     */
    private function __scrolled (me:Widget, dX:Float, dY:Float) : Void
    {

    }


    /**
     * Initialize this widget (without children)
     */
    override private function __initializeSelf () : Void
    {
        super.__initializeSelf();
        refresh();
    }


    /**
     * Creates new widget for list item
     */
    private function __createItemWidget () : ListItem<D>
    {
        return (itemFactory == null ? new T() : itemFactory());
    }


    /**
     * Setter `data`
     */
    private function set_data (value:Array<D>) : Array<D>
    {
        __data = value;

        if (initialized) refresh();

        return value;
    }


    /** Getters */
    private function get_data ()    return __data;

}//class ScrollList<T>