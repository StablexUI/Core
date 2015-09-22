package sx.properties;

import sx.properties.HorizontalAlign;
import sx.properties.VerticalAlign;



/**
 * Content alignment
 *
 */
class Align
{

    /** Horizontal alignment */
    public var horizontal (get,set) : HorizontalAlign;
    private var __horizontal : HorizontalAlign = HNone;
    /** Vertical alignment */
    public var vertical (get,set) : VerticalAlign;
    private var __vertical : VerticalAlign = VNone;

    /**
     * Callback to invoke when alignment settings changed.
     *
     * @param   Bool    Indicates if `horizontal` alignment changed.
     * @param   Bool    Indicates if `vertical` alignment changed.
     */
    public var onChange : Null<Bool->Bool->Void>;


    /**
     * Constructor
     */
    public function new (horizontal:HorizontalAlign = HNone, vertical:VerticalAlign = VNone) : Void
    {
        __horizontal = horizontal;
        __vertical   = vertical;
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
     * Call `onChange` if provided
     */
    private inline function __invokeOnChange (horizontalChanged:Bool, verticalChanged:Bool) : Void
    {
        if (onChange != null) onChange(horizontalChanged, verticalChanged);
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