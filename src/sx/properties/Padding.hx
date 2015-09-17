package sx.properties;

import sx.geom.Orientation;
import sx.geom.Unit;
import sx.properties.Size;



/**
 * Describes 4 directinal padding
 *
 */
class Padding
{
    /** Left border padding */
    public var left (default,null) : Size;
    /** Right border padding */
    public var right (default,null) : Size;
    /** Top border padding */
    public var top (default,null) : Size;
    /** Bottom border padding */
    public var bottom (default,null) : Size;

    /** Should provide owner width to specify left/right padding with percentage. */
    public var ownerWidth : Null< Void->Size >;
    /** Should provide owner height to specify top/bottom padding with percentage. */
    public var ownerHeight : Null< Void->Size >;

    /** Callback to invoke when padding settings changed */
    public var onChange : Null<Void->Void>;


    /**
     * Constructor
     */
    public function new () : Void
    {
        left   = new Size(Horizontal);
        right  = new Size(Horizontal);
        top    = new Size(Vertical);
        bottom = new Size(Vertical);

        left.onChange   = __sideChanged;
        right.onChange  = __sideChanged;
        top.onChange    = __sideChanged;
        bottom.onChange = __sideChanged;
    }



    /**
     * Called when a padding component changed
     */
    private function __sideChanged () : Void
    {
        if (onChange != null) onChange();
    }


}//class Padding