package sx.widgets;

import sx.widgets.base.Box;
import sx.widgets.ListItem;

using sx.tools.WidgetTools;
using sx.tools.PropertiesTools;


/**
 * Scrollable one-dimensional list of some typical items.
 *
 * :WARNING:
 * Not finished
 */
class ScrollList<T:ListItem<D>> extends Box
{
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


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        __items = [];
    }


    /**
     * Refresh items representation in this list
     */
    public function refresh () : Void
    {
        if (__data != null) {
            var sizeDip = this.size(oritentation).dip;
            var gapDip  = __lineLayout.gap.dip;

            var contentSizeDip = __lineLayout.padding.sum(oritentation);
            var item : T;
            for (i in 0...__data.length) {
                if (__items.length <= i) {
                    item = __createItemWidget();
                    __items.push(item);
                    addChild(item);
                }

                item = __items[i];
                item.data = __data[i];

                contentSizeDip += item.size(oritentation).dip;
                if (i * gapDip + contentSizeDip >= ) {
                    break;
                }
            }
        }
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