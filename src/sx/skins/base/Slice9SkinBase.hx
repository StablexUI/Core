package sx.skins.base;

import sx.backend.BitmapData;
import sx.skins.Skin;



/**
 * Base implementation for Slice9Skin
 *
 */
class Slice9SkinBase extends Skin
{
    /** Bitmap to slice for this skin */
    public var bitmapData : BitmapData = null;
    /** should we use smoothing? */
    public var smooth : Bool = true;
    /**
     * Where to slice skin bitmap.
     * Takes 4 floats: vertical left, vertical right, horizontal top, horizontal bottom guidelines for slicing.
     * If the floats are less than 1, they indicate a percentage of the picture where it should be cut.
     * If they are larger than or equal to 1 they are pixels and should be integer values.
     */
    public var slice : Array<Float> = null;


    /**
     * Returns the correct slice value in pixels.
     * If `value` is less than 1 we return a part of the `total` value passed.
     * If `value` is larger or equal to 1 we return the `value` value rounded.
     */
    private function __sliceSize(value:Float, total:Float) : Int
    {
        if (value >= 1) {
            return Math.round(value);
        } else {
            return Math.round(value * total);
        }
    }

}//class Slice9SkinBase