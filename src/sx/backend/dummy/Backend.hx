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
    /** Owner of this object */
    private var widget : Widget;
    /** Display list node */
    private var node : ArrayDisplayList;


    /**
     * Constructor
     */
    public function new (widget:Widget) : Void
    {
        this.widget = widget;
        node = new ArrayDisplayList(widget);
    }


    /**
     * Get parent widget
     */
    public function getParentWidget () : Null<Widget>
    {
        return (node.parent == null ? null : node.parent.widget);
    }


    /**
     * Get amount of child widgets in display list of current widget
     */
    public function getNumWidgets () : Int
    {
        return node.numChildren;
    }


    /**
     * Add `child` to display list of this widget.
     *
     * Returns added child.
     */
    public function addWidget (child:Widget) : Widget
    {
        node.addChild(child.backend.node);

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
        node.addChildAt(child.backend.node, index);

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
        var removed = node.removeChild(child.backend.node);

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
        var removed = node.removeChildAt(index);

        return (removed == null ? null : removed.widget);
    }


    /**
     * Remove all children from child with `beginIndex` position to child with `endIndex` (including).
     *
     * If index is negative, find required child from the end of display list.
     *
     * Returns amount of removed widgets.
     */
    public function removeWidgets (beginIndex:Int = 0, endIndex:Int = -1) : Int
    {
        return node.removeChildren(beginIndex, endIndex);
    }


    /**
     * Get index of a `child` in a list of children of this widget.
     *
     * @throws sx.exceptions.NotChildException If `child` is not direct child of this widget.
     */
    public function getWidgetIndex (child:Widget) : Int
    {
        return node.getChildIndex(child.backend.node);
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
        return node.setChildIndex(child.backend.node, index);
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
        var childNode = node.getChildAt(index);

        return (childNode == null ? null : childNode.widget);
    }


    /**
     * Swap two specified child widgets in display list.
     *
     * @throws sx.exceptions.NotChildException() If eighter `child1` or `child2` are not a child of this widget.
     */
    public function swapWidgets (child1:Widget, child2:Widget) : Void
    {
        node.swapChildren(child1.backend.node, child2.backend.node);
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
        node.swapChildrenAt(index1, index2);
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
     * Called after `widget.dispose()` invoked
     */
    public function widgetDisposed () : Void
    {
        widget = null;
        node   = null;
    }

}//class Backend