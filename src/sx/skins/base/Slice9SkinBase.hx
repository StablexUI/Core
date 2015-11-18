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
    /** should we stretch skin to fit widget's height? */
    public var stretch : Bool = true;
    /**
     * Where to slice skin bitmap.
     * Takes 4 floats: vertical left, vertical right, horizontal top, horizontal bottom guidelines for slicing.
     * If the floats are less than 1, they indicate a percentage of the picture where it should be cut.
     * If they are larger than or equal to 1 they are pixels and should be integer values.
     */
    public var slice : Array<Float> = null;



    /** Getters */
    private function get_bitmapData ()     return __bitmapData;
    private function set_smooth ()         return __smooth;
    private function set_stretch ()        return __stretch;

    /** Setters */
    private function set_bitmapData (v)     return __bitmapData = v;
    private function set_smooth (v)         return __smooth     = v;
    private function set_stretch (v)        return __stretch    = v;

}//class Slice9SkinBase