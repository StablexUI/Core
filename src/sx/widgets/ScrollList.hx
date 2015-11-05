package sx.widgets;

import sx.widgets.ListItem;



/**
 * Scrollable one-dimensional list of some typical items.
 *
 */
class ScrollList<T:ListItem<D>> extends Widget
{

    /** Data to display in list items */
    public var data : Array<D>;



}//class ScrollList<T>