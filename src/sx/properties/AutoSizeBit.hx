package sx.properties;



/**
 * Indicates if owner should atomaticaly adjust width/height based on content size
 *
 */
@:enum
abstract AutoSizeBit (Int) to Int
{

    var None   = 0;
    var Width  = 1;
    var Height = 2;
    var Both   = 3;


    /** Indicates if width should be calculated automatically */
    public var width (get,set) : Bool;
    /** Indicates if height should be calculated automatically */
    public var height (get,set) : Bool;


    /**
     * Create AutoSizeBit value from integer
     */
    @:from
    static private inline function fromInt (value:Int) : AutoSizeBit
    {
        return new AutoSizeBit(value & (Both:Int));
    }


    /**
     * Create AutoSizeBit value from boolean.
     *
     * `true`  means Both
     * `false` means None
     */
    @:from
    static private inline function fromBool (value:Bool) : AutoSizeBit
    {
        return (value ? Both : None);
    }


    /**
     * Constructor
     */
    public inline function new (value:Int) : Void
    {
        this = value;
    }


    /**
     * Indicates if at least one of `width` and `height` is `true`
     */
    public inline function either () : Bool
    {
        return (this != 0);
    }


    /**
     * Indicates if both `width` and `height` are `false`
     */
    public inline function neither () : Bool
    {
        return (this == 0);
    }


    /**
     * Indicates if both `width` and `height` are `true`
     */
    public inline function both () : Bool
    {
        return (this == (Both:Int));
    }


    /**
     * Description
     */
    @:op(A & B)
    private inline function combine (a:AutoSizeBit) : AutoSizeBit
    {
        return new AutoSizeBit(this & (a:Int));
    }


    /**
     * Setter `width`
     */
    private inline function set_width (value:Bool) : Bool
    {
        if (value) {
            this = this | (Width:Int);
        } else {
            this = this & ((Both:Int) - (Width:Int));
        }

        return value;
    }


    /**
     * Setter `height`
     */
    private inline function set_height (value:Bool) : Bool
    {
        if (value) {
            this = this | (Height:Int);
        } else {
            this = this & ((Both:Int) - (Height:Int));
        }

        return value;
    }


    /** Getters */
    private inline function get_width ()    return (this & (Width:Int) != 0);
    private inline function get_height ()   return (this & (Height:Int) != 0);

}//clAutoSizes AutoSizeBit