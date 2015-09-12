package sx.properties;



/**
 * Validation flags used by StablexUI.
 *
 * For cutom validation flags use bits form 16 upto 32.
 */
@:enum
abstract StandardValidationFlags (Int) to Int
{

    /** Transormation matrix (position, scale, skew, rotation) */
    var MATRIX = 1;
    /** width, height */
    var SIZE = 2;
    /** alpha */
    var ALPHA = 4;

}//abstract StandardValidationFlags


/**
 * Bit flags.
 * Indicates changed widget parameters which affect rendering.
 *
 */
abstract Validation (Int)
{

    /**
     * Constructor
     */
    public inline function new () : Void
    {
        this = 0;
    }


    /**
     * Invalidate widget property identified by `flag`
     */
    public inline function invalidate (flag:Int) : Void
    {
        this |= flag;
    }


    /**
     * Indicates if specified `flag` was invalidated
     */
    public inline function isInvalid (flag:Int) : Bool
    {
        return (this & flag) != 0;
    }


    /**
     * Indicates if specified `flag` was not invalidated.
     */
    public inline function isValid (flag:Int) : Bool
    {
        return (this & flag) == 0;
    }


    /**
     * Whether no flags were invalidated (which means no widget properties affecting rendering were changed).
     */
    public inline function isClean () : Bool
    {
        return this == 0;
    }


    /**
     * Whether some flags were invalidated (which means at least one widget property affecting rendering was changed).
     */
    public inline function isDirty () : Bool
    {
        return this != 0;
    }


    /**
     * Drop all flags (widget visualization will not be updated).
     */
    public inline function reset () : Void
    {
        this = 0;
    }

}//abstract Validation