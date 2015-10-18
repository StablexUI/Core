package sx.themes;

import sx.backend.TextFormat;
import sx.layout.LineLayout;
import sx.skins.ASkin;
import sx.skins.PaintSkin;
import sx.skins.Skin;
import sx.themes.flatui.ButtonStyle;
import sx.themes.flatui.ProgressBarStyle;
import sx.themes.flatui.TextInputStyle;
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
    static public var COLOR_TURQUOISE     = 0x1ABC9C;
    static public var COLOR_GREEN_SEA     = 0x16A085;
    static public var COLOR_EMERALD       = 0x2ECC71;
    static public var COLOR_NEPHRITIS     = 0x27AE60;
    static public var COLOR_PETER_RIVER   = 0x3498DB;
    static public var COLOR_BELIZE_HOLE   = 0x2980B9;
    static public var COLOR_AMETHYST      = 0x9B59B6;
    static public var COLOR_WISTERIA      = 0x8E44AD;
    static public var COLOR_WET_ASPHALT   = 0x34495E;
    static public var COLOR_MIDNIGHT_BLUE = 0x2C3E50;
    static public var COLOR_SUN_FLOWER    = 0xF1C40F;
    static public var COLOR_ORANGE        = 0xF39C12;
    static public var COLOR_CARROT        = 0xE67E22;
    static public var COLOR_PUMPKIN       = 0xD35400;
    static public var COLOR_ALIZARIN      = 0xE74C3C;
    static public var COLOR_POMEGRANATE   = 0xC0392B;
    static public var COLOR_CLOUDS        = 0xECF0F1;
    static public var COLOR_CLOUDS_DARK   = 0xEBEDEF;
    static public var COLOR_SILVER        = 0xBDC3C7;
    static public var COLOR_CONCRETE      = 0x95A5A6;
    static public var COLOR_ASBESTOS      = 0x7F8C8D;

    static public var SKIN_PRIMARY       = 'primarySkin';
    static public var SKIN_PRIMARY_DOWN  = 'primaryDownSkin';
    static public var SKIN_WARNING       = 'warningSkin';
    static public var SKIN_WARNING_DOWN  = 'warningDownSkin';
    static public var SKIN_CONCRETE      = 'silverSkin';
    static public var SKIN_CONCRETE_DOWN = 'silverDownSkin';
    static public var SKIN_DANGER        = 'dangerSkin';
    static public var SKIN_DANGER_DOWN   = 'dangerDownSkin';
    static public var SKIN_SUCCESS       = 'successSkin';
    static public var SKIN_SUCCESS_DOWN  = 'successDownSkin';
    static public var SKIN_INVERSE       = 'inverseSkin';
    static public var SKIN_INVERSE_DOWN  = 'inverseDownSkin';
    static public var SKIN_INFO          = 'infoSkin';
    static public var SKIN_INFO_DOWN     = 'infoDownSkin';
    static public var SKIN_DISABLED      = 'disabledSkin';
    static public var SKIN_INPUT_DEFAULT = 'defualtInputSkin';
    static public var SKIN_INPUT_ERROR   = 'errorInputSkin';
    static public var SKIN_INPUT_SUCCESS = 'successInputSkin';
    static public var SKIN_BACKGROUND    = 'backgroundSkin';

    static public var FONT_COLOR_LIGHT = 0xFFFFFF;
    static public var FONT_SIZE  = 14;

    /** Default width for widgets */
    static public var DEFAULT_WIDTH = 160;
    /** Default height for widgets */
    static public var DEFAULT_HEIGHT = 36;
    /** Default horizontal padding */
    static public var DEFAULT_PADDING_HORIZONTAL = 12;
    /** Default vertical padding */
    static public var DEFAULT_PADDING_VERTICAL = 10;
    /** Default distance between elements (e.g. icon and label of a button) */
    static public var DEFAULT_GAP = 8;
    /** Default radius for border corners */
    static public var DEFAULT_CORNER_RADIUS = 10;
    /** Default width for borders */
    static public var DEFAULT_BORDER_WIDTH = 2;


    /**
     * Creates "native" text format description.
     */
    static public dynamic function textFormat (sizePx:Float, color:Int, bold:Bool) : TextFormat
    {
        #if stablexui_flash
            var format = new flash.text.TextFormat('Arial');
            format.size  = Sx.snap(sizePx);
            format.color = color;
            format.bold  = bold;

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
    }


    /**
     * Define skins
     */
    private function __defineSkins () : Void
    {
        var map = [
            SKIN_PRIMARY      => COLOR_TURQUOISE,
            SKIN_PRIMARY_DOWN => COLOR_GREEN_SEA,

            SKIN_WARNING      => COLOR_SUN_FLOWER,
            SKIN_WARNING_DOWN => COLOR_ORANGE,

            SKIN_CONCRETE       => COLOR_CONCRETE,
            SKIN_CONCRETE_DOWN  => COLOR_ASBESTOS,

            SKIN_DANGER      => COLOR_ALIZARIN,
            SKIN_DANGER_DOWN => COLOR_POMEGRANATE,

            SKIN_SUCCESS      => COLOR_EMERALD,
            SKIN_SUCCESS_DOWN => COLOR_NEPHRITIS,

            SKIN_INVERSE      => COLOR_WET_ASPHALT,
            SKIN_INVERSE_DOWN => COLOR_MIDNIGHT_BLUE,

            SKIN_INFO      => COLOR_PETER_RIVER,
            SKIN_INFO_DOWN => COLOR_BELIZE_HOLE,

            SKIN_DISABLED   => COLOR_SILVER,
            SKIN_BACKGROUND => COLOR_CLOUDS_DARK
        ];
        var color;
        for (skinName in map.keys()) {
            color = map.get(skinName);
            Sx.registerSkin(skinName, __skinGenerator.bind(color));
        }

        map = [
            SKIN_INPUT_DEFAULT => COLOR_SILVER,
            SKIN_INPUT_SUCCESS => COLOR_EMERALD,
            SKIN_INPUT_ERROR   => COLOR_ALIZARIN
        ];
        for (skinName in map.keys()) {
            color = map.get(skinName);
            Sx.registerSkin(skinName, __borderSkinGenerator.bind(color));
        }
    }


    /**
     * Define styles
     */
    private function __defineStyles () : Void
    {
        ButtonStyle.defineStyles(this);
        TextInputStyle.defineStyles(this);
        ProgressBarStyle.defineStyles(this);
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


    /**
     * Returns callback which creates PaintSkin with specified border `color` and white background
     */
    private function __borderSkinGenerator (color:Int) : Skin
    {
        var skin = new PaintSkin();
        skin.color = 0xFFFFFF;
        skin.corners.dip = DEFAULT_CORNER_RADIUS;
        skin.border.color = color;
        skin.border.width.dip = DEFAULT_BORDER_WIDTH;

        return skin;
    }


}//class FlatUITheme