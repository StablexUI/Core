package sx.backend.dummy;

import sx.backend.interfaces.IBackend;
import sx.properties.displaylist.ArrayDisplayList;
import sx.widgets.Widget;



/**
 * Dummy backend implementation
 *
 */
class Backend implements IBackend
{
    /** Display list node */
    private var __node : ArrayDisplayList;


    /**
     * Constructor
     */
    public function new (widget:Widget) : Void
    {
        __node = new ArrayDisplayList(widget);
    }


    /**
     * Add `child` to display list of this widget.
     *
     * Returns added child.
     */
    public function addWidget (child:Widget) : Widget
    {
        __node.addChild(child.backend.__node);

        return child;
    }


    /**
     * Insert `child` at specified `index` of display list of this widget..
     *
     * If `index` is negative, calculate required index from the end of display list (`numChildren` + index).
     * If `index` is out of bounds, `child` will be added to the end (positive `index`) or to the beginning
     * (negative `index`) of display list.
     *
     * Returns added `child`.
     */
    public function addWidgetAt (child:Widget, index:Int) : Widget
    {
        __node.addChildAt(child.backend.__node, index);

        return child;
    }


    /**
     * Remove `child` from display list of this widget.
     *
     * Returns removed child.
     * Returns `null` if this widget is not a parent for this `child`.
     */
    public function removeWidget (child:Widget) : Null<Widget>
    {
        var removed = __node.removeChild(child.backend.__node);

        return (removed == null ? null : child);
    }


    /**
     * Remove child at `index` of display list of this widget.
     *
     * If `index` is negative, calculate required index from the end of display list (`numChildren` + index).
     *
     * Returns removed child or `null` if `index` is out of bounds.
     */
    public function removeWidgetAt (index:Int) : Null<Widget>
    {
        var removed = __node.removeChildAt(index);

        return (removed == null ? null : removed.widget);
    }


    /**
     * Get index of a `child` in a list of children of this widget.
     *
     * @throws sx.exceptions.NotChildException If `child` is not direct child of this widget.
     */
    public function getWidgetIndex (child:Widget) : Int
    {
        return __node.getChildIndex(child.backend.__node);
    }


    /**
     * Move `child` to specified `index` in display list.
     *
     * If `index` is greater then amount of children, `child` will be added to the end of display list.
     * If `index` is negative, required position will be calculated from the end of display list.
     * If `index` is negative and calculated position is less than zero, `child` will be added at the beginning of display list.
     *
     * Returns new position of a `child` in display list.
     *
     * @throws sx.exceptions.NotChildException If `child` is not direct child of this widget.
     */
    public function setWidgetIndex (child:Widget, index:Int) : Int
    {
        return __node.setChildIndex(child.backend.__node, index);
    }


    /**
     * Get child at specified `index`.
     *
     * If `index` is negative, required child is calculated from the end of display list.
     *
     * Returns child located at `index`, or returns `null` if `index` is out of bounds.
     */
    public function getWidgetAt (index:Int) : Null<Widget>
    {
        var childNode = __node.getChildAt(index);

        return (childNode == null ? null : childNode.widget);
    }


    /**
     * Swap two specified child widgets in display list.
     *
     * @throws sx.exceptions.NotChildException() If eighter `child1` or `child2` are not a child of this widget.
     */
    public function swapWidgets (child1:Widget, child2:Widget) : Void
    {
        __node.swapChildren(child1.backend.__node, child2.backend.__node);
    }


    /**
     * Swap children at specified indexes.
     *
     * If indices are negative, required children are calculated from the end of display list.
     *
     * @throws sx.exceptions.OutOfBoundsException
     */
    public function swapWidgetsAt (index1:Int, index2:Int) : Void
    {
        __node.swapChildrenAt(index1, index2);
    }


    /**
     * Called when origin of a widget was changed
     */
    public function widgetOriginChanged () : Void
    {

    }


    /**
     * Called when widget width/height is changed.
     */
    public function widgetResized () : Void
    {

    }


    /**
     * Called when widget position is changed.
     */
    public function widgetMoved () : Void
    {

    }


    /**
     * Called when widget.rotation is changed
     */
    public function widgetRotated () : Void
    {

    }

    /**
     * Called when widget.scaleX is changed
     */
    public function widgetScaledX () : Void
    {

    }


    /**
     * Called when widget.scaleY is changed
     */
    public function widgetScaledY () : Void
    {

    }


    /**
     * Called when widget.alpha is changed
     */
    public function widgetAlphaChanged () : Void
    {

    }


    /**
     * Called when widget.visible is changed
     */
    public function widgetVisibilityChanged () : Void
    {

    }


    /**
     * Called when skin of a widget was changed.
     */
    public function widgetSkinChanged () : Void
    {

    }


    /**
     * Called after `widget.dispose()` invoked
     */
    public function widgetDisposed () : Void
    {
        __node   = null;
    }

}//class Backend