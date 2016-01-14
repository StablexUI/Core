package sx.layout;

import sx.properties.abstracts.ASize;
import sx.properties.metric.Size;
import sx.properties.Orientation;


/**
 * Base class for layouts used with scrolled lists.
 * `autoArrange` is `false` by default.
 */
class ScrollLayout extends Layout
{
    /** Total amount of items in list */
    public var itemsCount : Int = 0;
    /** Typical item width. This value will be used instead of actial children widths. */
    public var itemWidth (get,set) : ASize;
    private var __itemWidth : Size;
    /** Typical item height. This value will be used instead of actial children heights. */
    public var itemHeight (get,set) : ASize;
    private var __itemHeight : Size;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        autoArrange = false;
    }


    /**
     * Calculate index of the first visible item in case content should be scrolled by `scrollX` and `scrollY` (in DIPs)
     */
    public function getFirstVisibleIndex (scrollX:Float, scrollY:Float) : Void
    {
        return itemsCount - 1;
    }


    /**
     * Calculate index of the last visible item in case content should be scrolled by `scrollX` and `scrollY` (in DIPs)
     */
    public function getFirstVisibleIndex (scrollX:Float, scrollY:Float) : Void
    {
        return itemsCount - 1;
    }


    /**
     * Calculates total size of all items like if they were arranged with this layout along specified `orientation` (DIPs)
     */
    public function getTotalSize (orientation:Orientation) : Float
    {
        return 0;
    }


    /** Getters */
    private function get_childWidth ()           return __childWidth;
    private function get_childHeight ()          return __childHeight;

    /** Setters */
    private function set_childWidth (v)      return __childWidth.copyValueFrom(v);
    private function set_childHeight (v)     return __childHeight.copyValueFrom(v);

}//class ScrollLayout