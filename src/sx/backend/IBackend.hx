package sx.backend;


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
     *
     * Returns added child.
     */
    public function addWidget (child:Widget) : Widget ;


    /**
     * Insert `child` at specified `index` of display list of this widget..
     *
     * If `index` is negative, calculate required index from the end of display list (`numChildren` + index).
     * If `index` is out of bounds, `child` will be added to the end (positive `index`) or to the beginning
     * (negative `index`) of display list.
     *
     * Returns added `child`.
     */
    public function addWidgetAt (child:Widget, index:Int) : Widget ;

    /**
     * Remove `child` from display list of this widget.
     *
     * Returns removed child.
     * Returns `null` if this widget is not a parent for this `child`.
     */
    public function removeWidget (child:Widget) : Null<Widget> ;


    /**
     * Remove child at `index` of display list of this widget.
     *
     * If `index` is negative, calculate required index from the end of display list (`numChildren` + index).
     *
     * Returns removed child or `null` if `index` is out of bounds.
     */
    public function removeWidgetAt (index:Int) : Null<Widget> ;

    /**
     * Remove all children from child with `beginIndex` position to child with `endIndex` (including).
     *
     * If index is negative, find required child from the end of display list.
     *
     * Returns removed widgets.
     */
    public function removeWidgets (beginIndex:Int = 0, endIndex:Int = -1) : Array<Widget> ;

    /**
     * Get index of a `child` in a list of children of this widget.
     *
     * @throws sx.exceptions.NotChildException If `child` is not direct child of this widget.
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
     *
     * @throws sx.exceptions.NotChildException If `child` is not direct child of this widget.
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
     *
     * @throws sx.exceptions.NotChildException() If eighter `child1` or `child2` are not a child of this widget.
     */
    public function swapWidgets (child1:Widget, child2:Widget) : Void ;

    /**
     * Swap children at specified indexes.
     *
     * If indices are negative, required children are calculated from the end of display list.
     *
     * @throws sx.exceptions.OutOfBoundsException
     */
    public function swapWidgetsAt (index1:Int, index2:Int) : Void ;

    /**
     * Method to remove cleanup and release this object for garbage collector.
     */
    public function dispose () : Void ;

}//interface IBackend