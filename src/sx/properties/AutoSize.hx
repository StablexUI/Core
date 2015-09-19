package sx.properties;



/**
 * Indicates if owner should atomaticaly adjust width/height
 *
 */
class AutoSize
{

    /** Automatically adjust width */
    public var width (get,set) : Bool;
    public var __width : Bool = false;
    /** Automatically adjust height */
    public var height (get,set) : Bool;
    public var __height : Bool = false;

    /**
     * Callback to invoke when autosize settings were changed
     *
     * @param   Bool    If `width` setting was changed
     * @param   Bool    If `height` setting was changed
     */
    public var onChange : Null<Bool->Bool->Void>;


    /**
     * Constructor
     */
    public function new (byDefault:Bool = false) : Void
    {
        __width  = byDefault;
        __height = byDefault;
    }


    /**
     * Set both the same `value` for `width` and `height`
     */
    public function set (value:Bool) : Void
    {
        __width  = value;
        __height = value;

        __invokeOnChange(true, true);
    }


    /**
     * Call `onChange` if defined
     */
    private inline function __invokeOnChange (widthChanged:Bool, heightChanged:Bool) : Void
    {
        if (onChange != null) onChange(widthChanged, heightChanged);
    }


    /**
     * Setter `width`
     */
    private function set_width (value:Bool) : Bool
    {
        __width = value;
        __invokeOnChange(true, false);

        return value;
    }


    /**
     * Setter `height`
     */
    private function set_height (value:Bool) : Bool
    {
        __height = value;
        __invokeOnChange(false, true);

        return value;
    }


    /** Getters */
    private function get_width ()  return __width;
    private function get_height () return __height;

}//class AutoSize