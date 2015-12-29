package sx.widgets.special;


/**
 * Items for various lists
 *
 */
class ListItem<T> extends Widget
{
    /** Index of `data` in data source. Used by `ScrollList` widget. */
    public var dataIndex (default,null) : Int = -1;
    /** Currently stored data */
    public var data (get,set) : Null<T>;
    private var __data : T;

    /** Next item in list */
    public var next (default,null)  : Null<ListItem<T>>;
    /** Previous item in list */
    public var previous (default,null) : Null<ListItem<T>>;


    /**
     * Description
     */
    public inline function linkNext (item:Null<ListItem<T>>) : Void
    {
        if (next != null) next.previous = null;
        next = item;
        if (item != null) item.previous = this;
    }


    /**
     * Description
     */
    public inline function linkPrevious (item:Null<ListItem<T>>) : Void
    {
        if (previous != null) previous.next = null;
        previous = item;
        if (item != null) item.next = this;
    }


    /**
     * Refresh data representation by this widget
     */
    public function refresh () : Void
    {

    }


    /**
     * Setter `data`
     */
    private function set_data (value:T) : T
    {
        __data = value;
        refresh();

        return __data;
    }


    /** Getters */
    private function get_data ()    return __data;

}//class ListItem<T>