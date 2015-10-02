package sx.properties;

import sx.signals.Signal;


/**
 * Horizontal align options.
 *
 */
@:enum abstract HorizontalAlign (String)
{

    var Left   = 'left';
    var Center = 'center';
    var Right  = 'right';
    var None   = 'none';

}//abstract HorizontalAlign


/**
 * Vertical align options.
 *
 */
@:enum abstract VerticalAlign (String)
{

    var Top    = 'top';
    var Middle = 'middle';
    var Bottom = 'bottom';
    var None   = 'none';

}//abstract VerticalAlign


/**
 * Content alignment
 *
 */
class Align
{

    /** Horizontal alignment */
    public var horizontal (get,set) : HorizontalAlign;
    private var __horizontal : HorizontalAlign = None;
    /** Vertical alignment */
    public var vertical (get,set) : VerticalAlign;
    private var __vertical : VerticalAlign = None;

    /**
     * Callback to invoke when alignment settings changed.
     *
     * @param   Bool    Indicates if `horizontal` alignment changed.
     * @param   Bool    Indicates if `vertical` alignment changed.
     */
    public var onChange (default,null) : Signal<Bool->Bool->Void>;


    /**
     * Constructor
     */
    public function new (horizontal:HorizontalAlign = None, vertical:VerticalAlign = None) : Void
    {
        __horizontal = horizontal;
        __vertical   = vertical;

        onChange = new Signal();
    }


    /**
     * Set both vertiacal and horizontal alignment.
     *
     * `onChange` will be invoked one time only.
     */
    public function set (horizontal:HorizontalAlign, vertical:VerticalAlign) : Void
    {
        __horizontal = horizontal;
        __vertical   = vertical;

        __invokeOnChange(true, true);
    }


    /**
     * Dispatches `onChange` signal
     */
    private inline function __invokeOnChange (horizontalChanged:Bool, verticalChanged:Bool) : Void
    {
        onChange.dispatch(horizontalChanged, verticalChanged);
    }


    /**
     * Setter `vertical`
     */
    private function set_vertical (value:VerticalAlign) : VerticalAlign
    {
        __vertical = value;
        __invokeOnChange(false, true);

        return value;
    }


    /**
     * Setter `horizontal`
     */
    private function set_horizontal (value:HorizontalAlign) : HorizontalAlign
    {
        __horizontal = value;
        __invokeOnChange(true, false);

        return value;
    }


    /** Getters */
    private function get_vertical ()    return __vertical;
    private function get_horizontal ()  return __horizontal;


}//class Align