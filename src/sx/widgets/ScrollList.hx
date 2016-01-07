package sx.widgets;

import sx.behavior.DragScrollBehavior;
import sx.properties.Orientation;
import sx.widgets.special.ListItem;
import sx.widgets.Widget;

using sx.tools.WidgetTools;
using sx.tools.PropertiesTools;


/**
 * Scrollable one-dimensional list of some typical items.
 *
 * :WARNING:
 * Does not work. Not finished.
 */
@:access(sx.widgets.special.ListItem)
class ScrollList<T> extends Scroll
{
    /** Description */
    public var orientation : Orientation = Vertical;
    /**
     * If your backend does not support clipping (`Widget.overflow = false` has no effect), then you can
     * set `scrollList.scaleBorderItems = true` to smoothly scale down border items when they are about to move out of
     * boundaries of the list.
     */
    // public var scaleBorderItems : Bool = false;
    /** Data to display in list items */
    public var data (get,set) : Null<Array<T>>;
    private var __data : Array<T>;
    /**
     * If provided this class will be used to create widgets for items in list.
     * Setting this property will automatically change `itemFactory` to `null`.
     */
    public var itemClass (get,set) : Null<Class<ListItem<T>>>;
    private var __itemClass : Class<ListItem<T>>;
    /**
     * If provided this callback will be used to create widgets for items in list.
     * Setting this property will automatically change `itemClass` to `null`.
     */
    public var itemFactory (get,set) : Null<Void->ListItem<T>>;
    private var __itemFactory : Void->ListItem<T>;

    /** First visible item in list */
    private var __firstItem : ListItem<T>;
    /** Last visible item in list */
    private var __lastItem : ListItem<T>;


    // /**
    //  * Constructor
    //  */
    // public function new () : Void
    // {
    //     super();

    //     __items = [];

    //     __scrollBehavior = new DragScrollBehavior(this);
    //     __scrollBehavior.onScroll.add(__scrolled);
    // }


    /**
     * Scroll by specified amount of DIPs
     */
    override public function scrollBy (dX:Float, dY:Float) : Void
    {
        super.scrollBy(dX, dY);
        if (data == null) return;

        if (dY < 0) {
            var item;
            while (__firstItem.canonicalCoordinate(orientation).dip > 0) {
                item = __lastItem;
                __lastItem = item.previous;
                __firstItem.linkPrevious(item);
                __firstItem = item;
                item.linkPrevious(null);

                __firstItem.dataIndex = __firstItem.next.dataIndex - 1;
                __firstItem.data = data[__firstItem.dataIndex];
                __firstItem.canonicalCoordinate(orientation).dip = __firstItem.next.canonicalCoordinate(orientation).dip - __firstItem.next.size(orientation).dip;
            }
            if (__lastItem.oppositeCanonicalCoordinate(orientation).dip > 0) {
                if (__lastItem.dataIndex < data.length - 1) {
                    item = __createItemWidget();
                    __lastItem.linkNext(item);
                    __lastItem = item;

                    item.top.dip = item.previous.top.dip + item.previous.height.dip;
                    addChild(item);

                    item.dataIndex = item.previous.dataIndex + 1;
                    item.data = data[item.dataIndex];
                }
            }

        } else if (dY > 0) {
            var item;
            while (__lastItem.oppositeCanonicalCoordinate(orientation).dip > 0) {
                if (__lastItem.dataIndex + 1 >= data.length) {
                    break;
                }

                item = __firstItem;
                __firstItem = item.next;
                __lastItem.linkNext(item);
                __lastItem = item;
                item.linkNext(null);

                __lastItem.dataIndex = __lastItem.previous.dataIndex + 1;
                __lastItem.data = data[__lastItem.dataIndex];
                __lastItem.canonicalCoordinate(orientation).dip = __lastItem.previous.canonicalCoordinate(orientation).dip + __lastItem.previous.size(orientation).dip;
            }
            if (__firstItem.canonicalCoordinate(orientation).dip > 0) {
                if (__firstItem.dataIndex > 0) {
                    item = __createItemWidget();
                    __firstItem.linkPrevious(item);
                    __firstItem = item;

                    item.top.dip = item.next.top.dip - item.next.height.dip;
                    addChild(item);

                    item.dataIndex = item.next.dataIndex - 1;
                    item.data = data[item.dataIndex];
                }
            }
        }
    }


    /**
     * Initial items creation
     */
    private function __createItems () : Void
    {
        if (data == null || !initialized) return;

        var item : ListItem<T> = null;
        var nextCoordinate = 0.0;
        for (i in 0...data.length) {
            if (i == 0) {
                __firstItem = __createItemWidget();
                item = __firstItem;
            } else {
                item.linkNext(__createItemWidget());
                item = item.next;
            }

            item.dataIndex = i;
            item.data = data[i];
            addChild(item);

            item.canonicalCoordinate(orientation).dip = nextCoordinate;
            nextCoordinate += item.size(orientation).dip;

            if (nextCoordinate >= this.size(orientation).dip) {
                break;
            }
        }
        __lastItem = item;

        __updateBothBars();
    }


    /**
     * Calculate maximum value for `scrollX` or `scrollY`
     */
    override private function __calculateMaxScrollValue (orientation:Orientation) : Float
    {
        if (orientation != this.orientation) return super.__calculateMaxScrollValue(orientation);
        if (__firstItem == null || __lastItem == null) return 0;

        var itemSize  = __firstItem.size(orientation).dip;
        var maxScroll = data.length * itemSize - this.size(orientation).dip;

        return maxScroll;
    }


    /**
     * Calculate current `scrollX` or `scrollY` value.
     */
    override private function __calculateScrollValue (orientation:Orientation) : Float
    {
        if (orientation != this.orientation) return super.__calculateScrollValue(orientation);
        if (__firstItem == null || __lastItem == null) return 0;

        var firstItemScroll = __firstItem.dataIndex * __firstItem.size(orientation).dip;
        var scrollValue = firstItemScroll - __firstItem.canonicalCoordinate(orientation).dip;

        return scrollValue;
    }


    // /**
    //  * Refresh items representation in this list
    //  */
    // public function refresh () : Void
    // {
    //     if (__data != null) {
    //         var sizeDip = this.size(orientation).dip;
    //         var contentSizeDip = 0.0;

    //         var item : ListItem<T>;
    //         for (i in 0...__data.length) {
    //             if (__items.length <= i) {
    //                 item = __createItemWidget();
    //                 __items.push(item);
    //                 addChild(item);
    //             }

    //             item = __items[i];
    //             item.data = __data[i];
    //             item.dataIndex = i;
    //             setChildIndex(item, i);

    //             contentSizeDip += item.size(orientation).dip;
    //             if (contentSizeDip >= sizeDip) {
    //                 break;
    //             }
    //         }
    //     }

    //     __updateBorderWidgets();
    // }


    // /**
    //  * Handle widgets which scrolled out of list bounds
    //  */
    // private function __updateBorderWidgets () : Void
    // {
    //     var child;
    //     for (i in 0...numChildren) {
    //         __updateChildIfBorder(getChildAt(i));
    //     }
    // }


    // /**
    //  * Description
    //  */
    // private function __updateChildIfBorder (child:Widget) : Bool
    // {
    //     return false;
    // }


    // /**
    //  * User wants to scroll content by `dX` and `dY`
    //  */
    // private function __scrolled (me:Widget, dX:Float, dY:Float) : Void
    // {

    // }


    // /**
    //  * Initialize this widget (without children)
    //  */
    // override private function __initializeSelf () : Void
    // {
    //     super.__initializeSelf();
    //     refresh();
    // }


    /**
     * Creates new widget for list item
     */
    private function __createItemWidget () : Null<ListItem<T>>
    {
        if (__itemClass != null) {
            return Type.createInstance(__itemClass, []);
        } else if (__itemFactory != null) {
            return __itemFactory();
        }

        return null;
    }


    /**
     * Setter `data`
     */
    private function set_data (value:Array<T>) : Array<T>
    {
        __data = value;
        __createItems();

        return value;
    }


    /**
     * Setter `itemClass`
     */
    private function set_itemClass (value:Class<ListItem<T>>) : Class<ListItem<T>>
    {
        __itemFactory = null;

        return __itemClass = value;
    }


    /**
     * Setter `itemFactory`
     */
    private function set_itemFactory (value:Void->ListItem<T>) : Void->ListItem<T>
    {
        __itemClass = null;

        return __itemFactory = value;
    }


    /** Getters */
    private function get_data ()            return __data;
    private function get_itemClass ()       return __itemClass;
    private function get_itemFactory ()     return __itemFactory;

}//class ScrollList<ListItem<T>>