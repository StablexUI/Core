package sx.backend.interfaces;

import sx.backend.Point;
import sx.widgets.Widget;


/**
 * Backend interface.
 *
 * It's not required to have `implement IBackend` on backend implementations,
 * but all methods listed here should be implemented and accessible from `sx` package.
 */
interface IBackend
{
    /**
     * Add `child` to display list of this widget.
     */
    public function addWidget (child:Widget) : Void ;

    /**
     * Insert `child` at specified `index` of display list of this widget..
     *
     * If `index` is negative, calculate required index from the end of display list (`numChildren` + index).
     * If `index` is out of bounds, `child` will be added to the end (positive `index`) or to the beginning
     * (negative `index`) of display list.
     */
    public function addWidgetAt (child:Widget, index:Int) : Void ;

    /**
     * Remove `child` from display list of this widget.
     */
    public function removeWidget (child:Widget) : Void ;

    /**
     * Remove child at `index` of display list of this widget.
     *
     * If `index` is negative, calculate required index from the end of display list (`numChildren` + index).
     *
     * Returns removed child or `null` if `index` is out of bounds.
     */
    public function removeWidgetAt (index:Int) : Null<Widget> ;

    /**
     * Get index of a `child` in a list of children of this widget.
     */
    public function getWidgetIndex (child:Widget) : Int ;

    /**
     * Move `child` to specified `index` in display list.
     *
     * If `index` is greater then amount of children, `child` will be added to the end of display list.
     * If `index` is negative, required position will be calculated from the end of display list.
     * If `index` is negative and calculated position is less than zero, `child` will be added at the beginning of display list.
     *
     * Returns new position of a `child` in display list.
     */
    public function setWidgetIndex (child:Widget, index:Int) : Int ;

    /**
     * Get child at specified `index`.
     *
     * If `index` is negative, required child is calculated from the end of display list.
     *
     * Returns child located at `index`, or returns `null` if `index` is out of bounds.
     */
    public function getWidgetAt (index:Int) : Null<Widget> ;

    /**
     * Swap two specified child widgets in display list.
     */
    public function swapWidgets (child1:Widget, child2:Widget) : Void ;

    /**
     * Swap children at specified indexes.
     *
     * If indices are negative, required children are calculated from the end of display list.
     */
    public function swapWidgetsAt (index1:Int, index2:Int) : Void ;

    /**
     * Convert global point to local point
     */
    public function widgetGlobalToLocal (point:Point) : Point ;

    /**
     * Convert local point to global point
     */
    public function widgetLocalToGlobal (point:Point) : Point ;

    /**
     * Called when origin of a widget was changed
     */
    public function widgetOriginChanged () : Void ;
    /**
     * Called when offset of a widget was changed
     */
    public function widgetOffsetChanged () : Void ;

    /**
     * Called when widget width/height is changed.
     */
    public function widgetResized () : Void ;

    /**
     * Called when widget position is changed.
     */
    public function widgetMoved () : Void ;

    /**
     * Called when widget rotation is changed
     */
    public function widgetRotated () : Void ;

    /**
     * Called when widget.scaleX is changed
     */
    public function widgetScaledX () : Void ;

    /**
     * Called when widget.scaleY is changed
     */
    public function widgetScaledY () : Void ;

    /**
     * Called when widget.alpha is changed
     */
    public function widgetAlphaChanged () : Void ;

    /**
     * Called when widget.visible is changed
     */
    public function widgetVisibilityChanged () : Void ;

    /**
     * Called when skin of a widget was changed
     */
    public function widgetSkinChanged () : Void ;

    /**
     * Called after `widget.dispose()` invoked
     */
    public function widgetDisposed () : Void ;

}//interface IBackend