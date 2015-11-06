package sx.widgets;

import sx.widgets.ListItem;



/**
 * Scrollable one-dimensional list of some typical items.
 *
 * :WARNING:
 * Not finished
 */
class ScrollList<T:ListItem<D>> extends Box
{

    /** Data to display in list items */
    public var data (get,set) : Null<Array<D>>;
    private var __data : Array<D>;
    /** If provided this callback will be used to create widgets for items in list */
    public var itemFactory : Null<Void->T>;

    /** Instantiated widgets for items */
    private var __items : Array<T>;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        __items = [];
    }


    /**
     * Refresh items representation in this list
     */
    public function refresh () : Void
    {
        if (__data != null) {
            var item : T;

            for (i in 0...__data.length) {
                if (__items.length < i) {
                    item = (itemFactory == null ? new T() : itemFactory());
                    __items.push(item);
                    addChild(item);
                }

                item = __items[i];
                item.data = __data[i];
            }
        }
    }


    /**
     * Initialize this widget (without children)
     */
    override private function __initializeSelf () : Void
    {
        super.__initializeSelf();
        refresh();
    }


    /**
     * Setter `data`
     */
    private function set_data (value:Array<D>) : Array<D>
    {
        __data = value;

        if (initialized) refresh();

        return value;
    }


    /** Getters */
    private function get_data ()    return __data;

}//class ScrollList<T>