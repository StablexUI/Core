package sx.widgets.special;



/**
 * Items for various lists
 *
 */
class ListItem<T> extends Widget
{

    /** Currently stored data */
    public var data (get,set) : Null<T>;
    private var __data : T;


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