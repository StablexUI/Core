package sx.widgets;

import sx.behavior.DragScrollBehavior;
import sx.ds.ObjectPool;
import sx.exceptions.InvalidArgumentException;
import sx.layout.Layout;
import sx.layout.ScrollLayout;
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

    /** value of `layout` casted to `ScrollLayout` */
    private var __scrollLayout : Null<ScrollLayout>;

    /** Current scroll value along X axis (DIPs) */
    private var __scrollX : Float = 0;
    /** Current scroll value along Y axis (DIPs) */
    private var __scrollY : Float = 0;
    // /** Maximux scroll value along X axis (DIPs) */
    // private var __maxScrollX : Float = 0;
    // /** Maximum scroll value along Y axis (DIPs) */
    // private var __maxScrollY : Float = 0;

    /** First visible item in list */
    private var __firstItem : ListItem<T>;
    /** Last visible item in list */
    private var __lastItem : ListItem<T>;
    /** Ready-to-use items */
    private var __freeItems : ObjectPool<ListItem<T>>;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        __freeItems = new ObjectPool();
    }


    /**
     * Scroll by specified amount of DIPs
     */
    override public function scrollBy (dX:Float, dY:Float) : Void
    {
        __scrollX += dX;
        __scrollY += dY;
        var rearrange = (dX != 0 || dY != 0);

        if (__scrollX < 0) {
            rearrange = true;
            __scrollX = 0;
        } else {
            var maxScrollX = __calculateMaxScrollValue(Horizontal);
            if (__scrollX > maxScrollX) {
                rearrange = true;
                __scrollX = maxScrollX;
            }
        }

        if (__scrollY < 0) {
            rearrange = true;
            __scrollY = 0;
        } else {
            var maxScrollY = __calculateMaxScrollValue(Vertical);
            if (__scrollY > maxScrollY) {
                rearrange = true;
                __scrollY = maxScrollY;
            }
        }

        if (rearrange && __scrollLayout != null) {
            // __scrollLayout.arrangeChildren();
            __updateItems();
        }
    }


    /**
     * Update visual representation of this list.
     */
    public function refresh () : Void
    {
        __updateItems();
    }


    /**
     * Update visible items state & positions
     */
    private function __updateItems () : Void
    {
        if (__scrollLayout == null || data == null) return;

        var firstIndex = __scrollLayout.getFirstVisibleIndex();
        var lastIndex  = __scrollLayout.getLastVisibleIndex();

        if (__firstItem != null) {
            var item = __firstItem;
            while (item != null) {
                if (item.dataIndex < firstIndex || item.dataIndex > lastIndex) {
                    if (item == __firstItem) {
                        __firstItem = item.next;
                    }
                    if (item == __lastItem) {
                        __lastItem = item.previous;
                    }
                    __recycleItemWidget(item);
                }
            }
        }

        if (__firstItem != null) {
            var index, item;
            for (i in -__firstItem.dataIndex...-(firstIndex - 1)) {
                index = -i;
                item  = __getFreeItemWidget();
                item.data = data[index];

                moveChildBefore(item, __firstItem);
                item.linkNext(__firstItem);
                __firstItem = item;

                item.visible = true;
                item.arrangeable = true;
            }
            for (i in __lastItem.dataIndex + 1...lastIndex + 1) {
                index = i;
                item  = __getFreeItemWidget();
                item.data = data[index];

                moveChildAfter(item, __lastItem);
                item.linkPrevious(__lastItem);
                __lastItem = item;

                item.visible = true;
                item.arrangeable = true;
            }
        } else {
            var item;
            for (index in firstIndex...lastIndex + 1) {
                item  = __getFreeItemWidget();
                item.data = data[index];

                if (index == firstIndex) {
                    __firstItem = item;
                    __lastItem  = item;
                } else {
                    __lastItem.linkNext(item);
                    __lastItem = item;
                }
            }
        }

        __scrollLayout.arrangeChildren();

        // var hasItems   = (__firstItem != null);
        // var childIndex = (__firstItem == null ? 0 : getChildIndex(__firstItem));
        // var item;
        // for (index in firstIndex...lastIndex+1) {
        //     if (!hasItems || index < __firstItem.dataIndex || index > __lastItem.dataIndex) {
        //         item = __getFreeItemWidget();
        //         item.data = data[index];

        //         setChildIndex(item, childIndex);

        //         item.visible = true;
        //         item.arrangeable = true;
        //     }

        //     childIndex++;
        // }
    }


    /**
     * Calculate maximum value for `scrollX` or `scrollY`
     */
    override private function __calculateMaxScrollValue (orientation:Orientation) : Float
    {
        if (__scrollLayout == null) return super.__calculateMaxScrollValue(orientation);

        var contentSize = __scrollLayout.getTotalSize(orientation);
        var maxScroll   = contentSize - this.size(orientation).dip;

        return maxScroll;
    }


    /**
     * Calculate current `scrollX` or `scrollY` value.
     */
    override private function __calculateScrollValue (orientation:Orientation) : Float
    {
        var scrollValue = switch (orientation) {
            case Horizontal : __scrollX;
            case Vertical   : __scrollY;
        }

        return scrollValue;
    }


    /**
     * Creates new widget for list item
     */
    private function __createItemWidget () : ListItem<T>
    {
        if (__itemClass != null) {
            return Type.createInstance(__itemClass, []);
        } else if (__itemFactory != null) {
            return __itemFactory();
        }

        return null;
    }


    /**
     * Get item to add to the list
     */
    private function __getFreeItemWidget () : ListItem<T>
    {
        var item = __freeItems.pop();
        if (item == null) {
            item = __createItemWidget();
            item.arrangeable = false;
            item.visible     = false;
            addChild(item);
        }

        return item;
    }


    /**
     * Store `item` to reuse in future
     */
    private function __recycleItemWidget (item:ListItem<T>) : Void
    {
        item.exclude();
        item.arrangeable = false;
        item.visible    = false;

        __freeItems.push(item);
    }


    /**
     * Setter `data`
     */
    private function set_data (value:Array<T>) : Array<T>
    {
        __data = value;
        if (__scrollLayout != null && value != null) {
            __scrollLayout.itemsCount = value.length;
        }

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


    /**
     * Setter `layout`
     */
    override private function set_layout (value:Layout) : Layout
    {
        if (!Std.is(value, ScrollLayout)) {
            throw new InvalidArgumentException('The only layout ScrollList widget accepts is ScrollLayout or his descendants.');
        }
        __scrollLayout = cast value;
        if (data != null) {
            __scrollLayout = data.length;
        }

        return super.set_layout(value);
    }


    /** Getters */
    private function get_data ()            return __data;
    private function get_itemClass ()       return __itemClass;
    private function get_itemFactory ()     return __itemFactory;

}//class ScrollList<ListItem<T>>