package sx.skins.base;

// import sx.properties.Border;
import sx.skins.Skin;



/**
 * Base implementation for Paint skin
 *
 */
class PaintSkinBase extends Skin
{
    // /** Border definition */
    // public var border (get,never) : Border;
    // private var __border : Border;
    /** RGB color value. Negative value means no fill. */
    public var color : Int = -1;
    /** Color transparency */
    public var alpha : Float = 1;


    // /**
    //  * Getter for `border`
    //  */
    // private function get_border () : Border
    // {
    //     if (__border == null) {
    //         __border = new Border();
    //     }

    //     return __border;
    // }

}//class PaintSkinBase