package sx.skins.base;

import sx.backend.BitmapData;
import sx.properties.abstracts.ASize;
import sx.properties.Border;
import sx.properties.metric.Size;
import sx.skins.Skin;



/**
 * Base implementation for Tile skin
 *
 */
class TileSkinBase extends Skin
{
    /** Border definition */
    public var border (get,never) : Border;
    private var __border : Border;
    /** Fill color transparency */
    public var alpha : Float = 1;
    /** Corners radius */
    public var corners (get,set) : ASize;
    private var __corners : Size;
    /** Bitmap to use for tiling */
    public var bitmapData : BitmapData = null;
    /** Should we use smoothing? */
    public var smooth : Bool = false;


    /**
     * Checks if skin has border defined
     */
    public inline function hasBorder () : Bool
    {
        return __border != null && border.width.dip > 0;
    }


    /**
     * Checks if skin has corners defined
     */
    public inline function hasCorners () : Bool
    {
        return __corners != null;
    }


    /**
     * Getter for `border`
     */
    private function get_border () : Border
    {
        if (__border == null) {
            __border = new Border();
            __border.pctSource = __widgetWidthProvider;
        }

        return __border;
    }


    /**
     * Getter for `corners`
     */
    private function get_corners () : ASize
    {
        if (__corners == null) {
            __corners = new Size();
            __corners.pctSource = __widgetWidthProvider;
        }

        return __corners;
    }


    /** Setters */
    private function set_corners (v)        return (corners:Size).copyValueFrom(v);

}//class TileSkinBase