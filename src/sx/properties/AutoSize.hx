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

    /** Callback to invoke when autosize settings were changed */
    public var onChange : Null<Void->Void>;


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

        __invokeOnChange();
    }


    /**
     * Call `onChange` if defined
     */
    private inline function __invokeOnChange () : Void
    {
        if (onChange != null) onChange();
    }


    /**
     * Setter `width`
     */
    private function set_width (value:Bool) : Bool
    {
        __width = value;
        __invokeOnChange();

        return value;
    }


    /**
     * Setter `height`
     */
    private function set_height (value:Bool) : Bool
    {
        __height = value;
        __invokeOnChange();

        return value;
    }


    /** Getters */
    private function get_width ()  return __width;
    private function get_height () return __height;

}//class AutoSize