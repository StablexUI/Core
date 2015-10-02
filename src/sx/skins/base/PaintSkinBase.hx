package sx.skins.base;

import sx.skins.Skin;



/**
 * Base implementation for Paint skin
 *
 */
class PaintSkinBase extends Skin
{

    /** RGB color value. Negative value means no fill. */
    public var color : Int = -1;
    /** Color transparency */
    public var alpha : Float = 1;

}//class PaintSkinBase