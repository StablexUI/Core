package sx.widgets;

import sx.behavior.ScrollBehavior;
import sx.signals.ScrollSignal;

using sx.tools.WidgetTools;



/**
 * Scroll container.
 *
 * Content scrolled by changing children coordinates.
 */
class Scroll extends Widget
{
    /**
     * Indicates if user is currently dragging scrolled content.
     * Assign `false` to stop dragging.
     * Assigning `true` while no real dragging is happening has no effect and `dragging` will stay `false`.
     */
    public var dragging (get,set) : Bool;
    /**
     * Indicates if content is currently dragged or scrolled by inertia.
     * Assign `false` to stop scrolling.
     * Assigning `true` while no real scrolling is happening has no effect and `scrolling` will stay `false`.
     */
    public var scrolling (get,set) : Bool;
    /** Enable/disable horizontal scrolling. Default: `true` */
    public var horizontalScroll (get,set) : Bool;
    /** Enable/disable vertical scrolling. Default: `true` */
    public var verticalScroll (get,set) : Bool;

    /** Scroll behavior implementation */
    private var __scrollBehavior : ScrollBehavior;

    /** Dispatched when content is scrolled */
    public var onScroll (get,never) : ScrollSignal;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        overflow = false;

        __scrollBehavior = new ScrollBehavior(this);
        __scrollBehavior.onScroll.add(__scrolled);
    }


    /**
     * Scroll by specified amount of DIPs
     */
    public function scrollBy (dX:Float, dY:Float) : Void
    {
        var minX = 0.0;
        var maxX = 0.0;
        var minY = 0.0;
        var maxY = 0.0;
        var horizontal = (dX != 0 && horizontalScroll);
        var vertical   = (dY != 0 && verticalScroll);

        var child : Widget;
        var left,top;
        for (i in 0...numChildren) {
            child = getChildAt(i);

            if (horizontal) {
                left = child.left.dip;
                if (i == 0 || left < minX) {
                    minX = left;
                }
                if (i == 0 || left + child.width.dip > maxX) {
                    maxX = left + child.width.dip;
                }
            }
            if (vertical) {
                top = child.top.dip;
                if (i == 0 || top < minY) {
                    minY = top;
                }
                if (i == 0 || top + child.height.dip > maxY) {
                    maxY = top + child.height.dip;
                }
            }
        }

        var contentWidth  = maxX - minX;
        var contentHeight = maxY - minY;

        horizontal = (horizontal && contentWidth > width.dip);
        vertical   = (vertical && contentHeight > height.dip);

        if (horizontal) {
            if (minX + dX > 0) {
                dX = -minX;
            } else if (maxX + dX < width.dip) {
                dX = width.dip - maxX;
            }
        }
        if (vertical) {
            if (minY + dY > 0) {
                dY = -minY;
            } else if (maxY + dY < height.dip) {
                dY = height.dip - maxY;
            }
        }

        for (i in 0...numChildren) {
            child = getChildAt(i);
            if (child.isArrangeable()) {
                if (horizontal) child.left.dip += dX;
                if (vertical) child.top.dip += dY;
            }
        }
    }


    /**
     * Method to cleanup and release this object for garbage collector.
     */
    override public function dispose (disposeChildren:Bool = true) : Void
    {
        __scrollBehavior.stop();

        super.dispose();
    }


    /**
     * Called when user wants to scroll
     */
    private function __scrolled (me:Widget, dX:Float, dY:Float) : Void
    {
        scrollBy(dX, dY);
    }


    /** Getters */
    private function get_dragging ()            return __scrollBehavior.dragging;
    private function get_scrolling ()           return __scrollBehavior.scrolling;
    private function get_horizontalScroll ()    return __scrollBehavior.horizontalScroll;
    private function get_verticalScroll ()      return __scrollBehavior.verticalScroll;
    private function get_onScroll ()            return __scrollBehavior.onScroll;

    /** Setters */
    private function set_dragging (v)            return __scrollBehavior.dragging = v;
    private function set_scrolling (v)           return __scrollBehavior.scrolling = v;
    private function set_horizontalScroll (v)    return __scrollBehavior.horizontalScroll = v;
    private function set_verticalScroll (v)      return __scrollBehavior.verticalScroll = v;

}//class Scroll