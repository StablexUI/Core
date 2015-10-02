package sx.tools;

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
     * Returns `true` if all padding components set to `0`
     */
    @:access(sx.properties.metric.Size)
    static public function isZero (padding:Padding) : Bool
    {
        var leftZero   = (padding.left.__value == 0);
        var rightZero  = (padding.right.__value == 0);
        var topZero    = (padding.top.__value == 0);
        var bottomZero = (padding.bottom.__value == 0);

        return (leftZero && rightZero && topZero && bottomZero);
    }

}//class PaddingTools