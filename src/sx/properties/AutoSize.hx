package sx.properties;

import sx.signals.Signal;



/**
 * Indicates if owner should atomaticaly adjust width/height
 *
 */
class AutoSize
{

    /** Automatically adjust width */
    public var width (get,set) : Bool;
    private var __width : Bool = false;
    /** Automatically adjust height */
    public var height (get,set) : Bool;
    private var __height : Bool = false;

    /**
     * Callback to invoke when autosize settings were changed
     *
     * @param   Bool    If `width` setting was changed
     * @param   Bool    If `height` setting was changed
     */
    public var onChange (default,null) : Signal<Bool->Bool->Void>;

    /** Indicates if this is a 'weak' instance which should be disposed immediately after usage */
    public var weak (default,null) : Bool = false;


    /**
     * Constructor
     */
    public function new (byDefault:Bool = false) : Void
    {
        __width  = byDefault;
        __height = byDefault;

        onChange = new Signal();
    }


    /**
     * Returns `true` if either `width` or `height` is `true`
     */
    public function either () : Bool
    {
        return width || height;
    }


    /**
     * Returns `true` if both `width` and `height` are `false`
     */
    public function neither () : Bool
    {
        return !width && !height;
    }


    /**
     * Indicates if both `width` and `height` are `true`
     */
    public function both () : Bool
    {
        return width && height;
    }


    /**
     * Set both `width` and `height`.
     *
     * Dispatches single `onChange` signal.
     */
    public function set (width:Bool, height:Bool) : Void
    {
        var widthChanged  = (__width != width);
        var heightChanged = (__height != height);

        __width  = width;
        __height = height;

        if (widthChanged || heightChanged) {
            __invokeOnChange(widthChanged, heightChanged);
        }
    }


    /**
     * Copy value and units from another instance
     *
     * Returns current instance.
     */
    public function copyValueFrom (autoSize:AutoSize) : AutoSize
    {
        set(autoSize.width, autoSize.height);
        if (autoSize.weak) autoSize.dispose();

        return this;
    }


    /**
     * For overriding by disposable descendants
     */
    public function dispose () : Void
    {

    }


    /**
     * Dispatches `onChange` signal
     */
    private inline function __invokeOnChange (horizontalChanged:Bool, verticalChanged:Bool) : Void
    {
        onChange.dispatch(horizontalChanged, verticalChanged);
    }


    /**
     * Setter `width`
     */
    private function set_width (value:Bool) : Bool
    {
        if (__width != value) {
            __width = value;
            __invokeOnChange(true, false);
        } else {
            __width = value;
        }


        return value;
    }


    /**
     * Setter `height`
     */
    private function set_height (value:Bool) : Bool
    {
        if (__height != value) {
            __height = value;
            __invokeOnChange(false, true);
        } else {
            __height = value;
        }

        return value;
    }


    /** Getters */
    private function get_width ()   return __width;
    private function get_height ()  return __height;

}//class AutoSize