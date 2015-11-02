package sx.tools;

import sx.properties.metric.Units;
import sx.properties.Side;
import sx.properties.Orientation;
import sx.properties.metric.Size;
import sx.properties.metric.Padding;



/**
 * sx.properties.Orientation
 *
 */
class OrientationTools
{

    /**
     * Returns opposite orientation
     */
    static public inline function opposite (orientation:Orientation) : Orientation
    {
        return switch (orientation) {
            case Vertical   : Horizontal;
            case Horizontal : Vertical;
        }
    }

}//class OrientationTools


/**
 * sx.properties.metric.Size
 *
 */
class SizeTools
{

    /**
     * Indicates if value is `0` regardless `units`
     */
    @:access(sx.properties.metric.Size)
    static public inline function isZero (size:Size) : Bool
    {
        return size.__value == 0;
    }


    /**
     * Indicates if value is not `0` regardless `units`
     */
    @:access(sx.properties.metric.Size)
    static public inline function notZero (size:Size) : Bool
    {
        return size.__value != 0;
    }


    /**
     * Get `size` value measured in specified `units`
     */
    static public inline function get (size:Size, units:Units) : Float
    {
        return switch (units) {
            case Dip     : size.dip;
            case Pixel   : size.px;
            case Percent : size.pct;
        }
    }


}//class SizeTools


/**
 * Helper functions for padding
 *
 */
class PaddingTools
{


    /**
     * Total padding along one dimension (left + right or top + bottom) in pixels.
     */
    static public function sum (padding:Padding, orientation:Orientation) : Float
    {
        return switch (orientation) {
            case Horizontal : padding.left.px + padding.right.px;
            case Vertical   : padding.top.px + padding.bottom.px;
        }
    }


    /**
     * Get specified padding component
     */
    static public function side (padding:Padding, side:Side) : Size
    {
        return switch (side) {
            case Left   : padding.left;
            case Right  : padding.right;
            case Top    : padding.top;
            case Bottom : padding.bottom;
        }
    }


    /**
     * Get padding component from opposite to the specified `side`
     */
    static public function oppositeSide (padding:Padding, side:Side) : Size
    {
        return switch (side) {
            case Left   : padding.right;
            case Right  : padding.left;
            case Top    : padding.bottom;
            case Bottom : padding.top;
        }
    }


    /**
     * Returns `true` if all padding components set to `0`
     */
    @:access(sx.properties.metric.Size)
    static public function isZero (padding:Padding) : Bool
    {
        var leftZero   = ((padding.left:Size).__value == 0);
        var rightZero  = ((padding.right:Size).__value == 0);
        var topZero    = ((padding.top:Size).__value == 0);
        var bottomZero = ((padding.bottom:Size).__value == 0);

        return (leftZero && rightZero && topZero && bottomZero);
    }

}//class PaddingTools