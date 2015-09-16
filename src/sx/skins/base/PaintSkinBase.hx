package sx.skins.base;

import sx.skins.Skin;



/**
 * Base implementation for Paint skin
 *
 */
class PaintSkinBase extends Skin
{

    /** RGB color value. Negative value means no fill. */
    public var color (default,set) : Int = -1;
    /** Color transparency */
    public var alpha (default,set) : Float = 1;


    /**
     * Setter `color`
     */
    private function set_color (value:Int) : Int
    {
        color = value;
        __invokeOnChange();

        return value;
    }


    /**
     * Setter `alpha`
     */
    private function set_alpha (value:Float) : Float
    {
        alpha = value;
        __invokeOnChange();

        return value;
    }

}//class PaintSkinBase