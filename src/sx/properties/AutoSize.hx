package sx.properties;

import sx.signals.Signal;



/**
 * Indicates if owner should atomaticaly adjust width/height
 *
 */
class AutoSize
{

    /** Automatically adjust width */
    public var width (default,set) : Bool = false;
    /** Automatically adjust height */
    public var height (default,set) : Bool = false;

    /**
     * Callback to invoke when autosize settings were changed
     *
     * @param   Bool    If `width` setting was changed
     * @param   Bool    If `height` setting was changed
     */
    public var onChange (default,null) : Signal<Bool->Bool->Void>;

    /** Indicates if this is a 'weak' instance which should be disposed immediately after usage */
    public var weak (default,null) : Bool = false;

    /** Do not dispatch `onChange` */
    private var __silentChanges : Bool = false;


    /**
     * Constructor
     */
    public function new (byDefault:Bool = false) : Void
    {
        set(byDefault);

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
     * Set both the same `value` for `width` and `height`
     */
    public function set (value:Bool) : Void
    {
        __silentChanges = true;
        width  = value;
        height = value;
        __silentChanges = false;

        __invokeOnChange(true, true);
    }


    /**
     * Copy value and units from another instance
     *
     * Returns current instance.
     */
    public function copyValueFrom (autoSize:AutoSize) : AutoSize
    {
        var widthChanged  = (width != autoSize.width);
        var heightChanged = (height != autoSize.height);

        __silentChanges = true;
        width  = autoSize.width;
        height = autoSize.height;
        __silentChanges = false;

        if (widthChanged || heightChanged) {
            __invokeOnChange(widthChanged, heightChanged);
        }

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
        if (!__silentChanges) {
            onChange.dispatch(horizontalChanged, verticalChanged);
        }
    }


    /**
     * Setter `width`
     */
    private function set_width (value:Bool) : Bool
    {
        if (width != value) {
            width = value;
            __invokeOnChange(true, false);
        } else {
            width = value;
        }


        return value;
    }


    /**
     * Setter `height`
     */
    private function set_height (value:Bool) : Bool
    {
        if (height != value) {
            height = value;
            __invokeOnChange(false, true);
        } else {
            height = value;
        }

        return value;
    }


}//class AutoSize