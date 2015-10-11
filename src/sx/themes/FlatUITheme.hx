package sx.themes;

import sx.backend.TextFormat;
import sx.layout.LineLayout;
import sx.skins.ASkin;
import sx.skins.PaintSkin;
import sx.skins.Skin;
import sx.themes.flatui.ButtonStyle;
import sx.widgets.Widget;
import sx.Sx;
import sx.widgets.Button;


/**
 * Theme inspired by FlatUI Free.
 *
 * @link http://designmodo.com/
 */
class FlatUITheme extends Theme
{
    static public inline var COLOR_TURQUOISE     = 0x1ABC9C;
    static public inline var COLOR_GREEN_SEA     = 0x16A085;
    static public inline var COLOR_EMERALD       = 0x2ECC71;
    static public inline var COLOR_NEPHRITIS     = 0x27AE60;
    static public inline var COLOR_PETER_RIVER   = 0x3498DB;
    static public inline var COLOR_BELIZE_HOLE   = 0x2980B9;
    static public inline var COLOR_AMETHYST      = 0x9B59B6;
    static public inline var COLOR_WISTERIA      = 0x8E44AD;
    static public inline var COLOR_WET_ASPHALT   = 0x34495E;
    static public inline var COLOR_MIDNIGHT_BLUE = 0x2C3E50;
    static public inline var COLOR_SUN_FLOWER    = 0xF1C40F;
    static public inline var COLOR_ORANGE        = 0xF39C12;
    static public inline var COLOR_CARROT        = 0xE67E22;
    static public inline var COLOR_PUMPKIN       = 0xD35400;
    static public inline var COLOR_ALIZARIN      = 0xE74C3C;
    static public inline var COLOR_POMEGRANATE   = 0xC0392B;
    static public inline var COLOR_CLOUDS        = 0xECF0F1;
    static public inline var COLOR_SILVER        = 0xBDC3C7;
    static public inline var COLOR_CONCRETE      = 0x95A5A6;
    static public inline var COLOR_ASBESTOS      = 0x7F8C8D;

    static public inline var SKIN_PRIMARY       = 'primarySkin';
    static public inline var SKIN_PRIMARY_DOWN  = 'primaryDownSkin';
    static public inline var SKIN_WARNING       = 'warningSkin';
    static public inline var SKIN_WARNING_DOWN  = 'warningDownSkin';
    static public inline var SKIN_CONCRETE      = 'silverSkin';
    static public inline var SKIN_CONCRETE_DOWN = 'silverDownSkin';
    static public inline var SKIN_DANGER        = 'dangerSkin';
    static public inline var SKIN_DANGER_DOWN   = 'dangerDownSkin';
    static public inline var SKIN_SUCCESS       = 'successSkin';
    static public inline var SKIN_SUCCESS_DOWN  = 'successDownSkin';
    static public inline var SKIN_INVERSE       = 'inverseSkin';
    static public inline var SKIN_INVERSE_DOWN  = 'inverseDownSkin';
    static public inline var SKIN_INFO          = 'infoSkin';
    static public inline var SKIN_INFO_DOWN     = 'infoDownSkin';
    static public inline var SKIN_DISABLED      = 'disabledSkin';

    static public inline var FONT_COLOR = 0xFFFFFF;
    static public inline var FONT_SIZE  = 17;

    /** Default width for widgets */
    static public inline var DEFAULT_WIDTH = 214;
    /** Default height for widgets */
    static public inline var DEFAULT_HEIGHT = 44;
    /** Default horizontal padding */
    static public inline var DEFAULT_PADDING_HORIZONTAL = 19;
    /** Default vertical padding */
    static public inline var DEFAULT_PADDING_VERTICAL = 10;
    /** Default distance between elements (e.g. icon and label of a button) */
    static public inline var DEFAULT_GAP = 10;
    /** Default radius for border corners */
    static public inline var DEFAULT_CORNER_RADIUS = 10;


    /**
     * Creates "native" text format description.
     */
    static public dynamic function textFormat (sizePx:Float, color:Int) : TextFormat
    {
        #if stablexui_flash
            var format = new flash.text.TextFormat('Arial');
            format.size  = sizePx;
            format.color = color;
            format.bold  = true;

            return format;
        #else
            return null;
        #end
    }


    /**
     * Initialize theme styles
     */
    override private function initialize () : Void
    {
        __defineSkins();
        __defineStyles();
        finalize();
    }


    /**
     * Define skins
     */
    private function __defineSkins () : Void
    {
        var map = [
            SKIN_PRIMARY       => COLOR_TURQUOISE,
            SKIN_PRIMARY_DOWN  => COLOR_GREEN_SEA,

            SKIN_WARNING       => COLOR_SUN_FLOWER,
            SKIN_WARNING_DOWN  => COLOR_ORANGE,

            SKIN_CONCRETE       => COLOR_CONCRETE,
            SKIN_CONCRETE_DOWN  => COLOR_ASBESTOS,

            SKIN_DANGER       => COLOR_ALIZARIN,
            SKIN_DANGER_DOWN  => COLOR_POMEGRANATE,

            SKIN_SUCCESS       => COLOR_EMERALD,
            SKIN_SUCCESS_DOWN  => COLOR_NEPHRITIS,

            SKIN_INVERSE       => COLOR_WET_ASPHALT,
            SKIN_INVERSE_DOWN  => COLOR_MIDNIGHT_BLUE,

            SKIN_INFO       => COLOR_PETER_RIVER,
            SKIN_INFO_DOWN  => COLOR_BELIZE_HOLE,

            SKIN_DISABLED => COLOR_SILVER
        ];

        var color;
        for (skinName in map.keys()) {
            color = map.get(skinName);
            Sx.registerSkin(skinName, __skinGenerator.bind(color));
        }
    }


    /**
     * Define styles
     */
    private function __defineStyles () : Void
    {
        ButtonStyle.defineStyles(this);
    }


    /**
     * Returns callback which creates PaintSkin with specified `color`
     */
    private function __skinGenerator (color:Int) : Skin
    {
        var skin = new PaintSkin();
        skin.color = color;
        skin.corners.dip = DEFAULT_CORNER_RADIUS;

        return skin;
    }


}//class FlatUITheme