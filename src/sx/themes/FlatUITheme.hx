package sx.themes;

import sx.backend.TextFormat;
import sx.backend.BitmapData;
import sx.layout.LineLayout;
import sx.skins.ASkin;
import sx.skins.PaintSkin;
import sx.skins.Skin;
import sx.themes.flatui.Icons;
import sx.themes.flatui.styles.ButtonStyle;
import sx.themes.flatui.styles.CheckBoxStyle;
import sx.themes.flatui.styles.ProgressBarStyle;
import sx.themes.flatui.styles.RadioStyle;
import sx.themes.flatui.styles.SliderStyle;
import sx.themes.flatui.styles.TextInputStyle;
import sx.themes.flatui.styles.TabBarStyle;
import sx.themes.flatui.styles.TabButtonStyle;
import sx.widgets.Text;
import sx.widgets.Widget;
import sx.Sx;
import sx.widgets.Button;

using sx.Sx;
using String;


/**
 * Theme based on FlatUI Free.
 *
 * @link http://designmodo.com/
 */
class FlatUITheme extends Theme
{
    static public var COLOR_TURQUOISE_LIGHT   = 0x48c9b0;
    static public var COLOR_TURQUOISE         = 0x1ABC9C;
    static public var COLOR_GREEN_SEA         = 0x16A085;

    static public var COLOR_EMERALD_LIGHT     = 0x58d68d;
    static public var COLOR_EMERALD           = 0x2ECC71;
    static public var COLOR_NEPHRITIS         = 0x27AE60;

    static public var COLOR_PETER_RIVER_LIGHT = 0x5dade2;
    static public var COLOR_PETER_RIVER       = 0x3498DB;
    static public var COLOR_BELIZE_HOLE       = 0x2980B9;

    static public var COLOR_AMETHYST_LIGHT    = 0xc59fd4;
    static public var COLOR_AMETHYST          = 0x9B59B6;
    static public var COLOR_WISTERIA          = 0x8E44AD;

    static public var COLOR_WET_ASPHALT_LIGHT = 0x415b76;
    static public var COLOR_WET_ASPHALT       = 0x34495E;
    static public var COLOR_MIDNIGHT_BLUE     = 0x2C3E50;

    static public var COLOR_SUN_FLOWER_LIGHT  = 0xf4d313;
    static public var COLOR_SUN_FLOWER        = 0xF1C40F;
    static public var COLOR_ORANGE            = 0xF39C12;

    static public var COLOR_CARROT_LIGHT      = 0xf0b47f;
    static public var COLOR_CARROT            = 0xE67E22;
    static public var COLOR_PUMPKIN           = 0xD35400;

    static public var COLOR_ALIZARIN_LIGHT    = 0xec7063;
    static public var COLOR_ALIZARIN          = 0xE74C3C;
    static public var COLOR_POMEGRANATE       = 0xC0392B;

    static public var COLOR_CLOUDS            = 0xECF0F1;
    static public var COLOR_CLOUDS_DARK       = 0xEBEDEF;

    static public var COLOR_SILVER_LIGHT      = 0xcacfd2;
    static public var COLOR_SILVER            = 0xBDC3C7;
    static public var COLOR_SILVER_DARK       = 0xa1a6a9;

    static public var COLOR_CONCRETE          = 0x95A5A6;
    static public var COLOR_ASBESTOS          = 0x7F8C8D;

    static public var SKIN_PRIMARY_HOVER = 'primaryHoverSkin';
    static public var SKIN_PRIMARY       = 'primarySkin';
    static public var SKIN_PRIMARY_DOWN  = 'primaryDownSkin';
    static public var SKIN_WARNING_HOVER = 'warningHoverSkin';
    static public var SKIN_WARNING       = 'warningSkin';
    static public var SKIN_WARNING_DOWN  = 'warningDownSkin';
    static public var SKIN_SILVER_HOVER  = 'silverHoverSkin';
    static public var SKIN_SILVER        = 'silverSkin';
    static public var SKIN_SILVER_DOWN   = 'silverDownSkin';
    static public var SKIN_DANGER_HOVER  = 'dangerHoverSkin';
    static public var SKIN_DANGER        = 'dangerSkin';
    static public var SKIN_DANGER_DOWN   = 'dangerDownSkin';
    static public var SKIN_SUCCESS_HOVER = 'successHoverSkin';
    static public var SKIN_SUCCESS       = 'successSkin';
    static public var SKIN_SUCCESS_DOWN  = 'successDownSkin';
    static public var SKIN_INVERSE_HOVER = 'inverseHoverSkin';
    static public var SKIN_INVERSE       = 'inverseSkin';
    static public var SKIN_INVERSE_DOWN  = 'inverseDownSkin';
    static public var SKIN_INFO_HOVER    = 'infoHoverSkin';
    static public var SKIN_INFO          = 'infoSkin';
    static public var SKIN_INFO_DOWN     = 'infoDownSkin';
    static public var SKIN_DISABLED      = 'disabledSkin';
    static public var SKIN_INPUT_DEFAULT = 'defualtInputSkin';
    static public var SKIN_INPUT_ERROR   = 'errorInputSkin';
    static public var SKIN_INPUT_SUCCESS = 'successInputSkin';
    static public var SKIN_BACKGROUND    = 'backgroundSkin';
    static public var SKIN_ASBESTOS      = 'asbestosSkin';

    static public var FONT_COLOR_LIGHT = 0xFFFFFF;
    static public var FONT_COLOR_DARK  = COLOR_WET_ASPHALT;
    static public var FONT_SIZE_BIG    = 18;
    static public var FONT_SIZE        = 14;
    static public var FONT_SIZE_SMALL  = 10;

    /** Default width for widgets */
    static public var DEFAULT_WIDTH = 160;
    /** Default height for widgets */
    static public var DEFAULT_HEIGHT = 36;
    /** Default size for icons */
    static public inline var DEFAULT_ICO_SIZE = 18;
    /** Default horizontal padding */
    static public var DEFAULT_PADDING_HORIZONTAL = 12;
    /** Default vertical padding */
    static public var DEFAULT_PADDING_VERTICAL = 10;
    /** Default distance between elements (e.g. icon and label of a button) */
    static public var DEFAULT_GAP = 8;
    /** Default radius for border corners */
    static public var DEFAULT_CORNER_RADIUS = 4;
    /** Default width for borders */
    static public var DEFAULT_BORDER_WIDTH = 2;
    /** Height for greater elements */
    static public inline var GREATER_HEIGHT = 50;
    /** Greater radius for border corners (e.g. for progress bars) */
    static public var GREATER_CORNER_RADIUS = 6;

#if stablexui_flash
    static private var __grayscaleFilter : flash.filters.ColorMatrixFilter;
#end

    /** Bitmaps ready for usage */
    static public var loadedBitmaps : Map<String,BitmapData> = new Map();


    /**
     * Creates "native" text format description.
     */
    static public dynamic function textFormat (sizePx:Float, color:Int, bold:Bool, font:String = null) : TextFormat
    {
        #if stablexui_flash
            if (font == null) font = 'Arial';
            var format = new flash.text.TextFormat(font);
            format.size  = Sx.snap(sizePx);
            format.color = color;
            format.bold  = bold;

            return format;
        #else
            return null;
        #end
    }


    /**
     * Set grayscale mode for `widget`
     */
    static public dynamic function onDisable (widget:Widget) : Void
    {
        #if stablexui_flash
            if (__grayscaleFilter == null) {
                __grayscaleFilter = new flash.filters.ColorMatrixFilter([
                    1.2 * 0.2225, 1.2 * 0.7169, 1.2 * 0.0606, 0, 0,
                    1.2 * 0.2225, 1.2 * 0.7169, 1.2 * 0.0606, 0, 0,
                    1.2 * 0.2225, 1.2 * 0.7169, 1.2 * 0.0606, 0, 0,
                         0,      0,      0, 1, 0
                ]);
            }

            var filters = widget.backend.filters;
            if (filters == null) filters = [];
            filters.push(__grayscaleFilter);

            widget.backend.filters = filters;
        #end
    }


    /**
     * Remove grayscale mode from `widget`
     */
    static public dynamic function onEnable (widget:Widget) : Void
    {
        #if stablexui_flash
            var filters = widget.backend.filters;
            if (filters != null && filters.length > 0) {
                for (i in 0...filters.length) {
                    if (Std.is(filters[i], flash.filters.ColorMatrixFilter)) {
                        var matrix = cast(filters[i], flash.filters.ColorMatrixFilter).matrix;
                        var isGrayscaleFilter = true;
                        for (j in 0...matrix.length) {
                            if (Math.abs(matrix[j] - __grayscaleFilter.matrix[j]) > 0.001) {
                                isGrayscaleFilter = false;
                                break;
                            }
                        }
                        if (isGrayscaleFilter) {
                            filters.remove(filters[i]);
                            widget.backend.filters = filters;
                            break;
                        }
                    }
                }
            }
        #end
    }


    /**
     * Initialize theme styles
     */
    override private function initialize () : Void
    {
        __defineSkins();
        __defineStyles();
        Sx.addInitTask(Icons.loadBitmaps);
    }


    /**
     * Applies style from `widget.style` to `widget`.
     *
     * Does nothing if `widget.style` is `null` or does not exist.
     */
    override public function apply (widget:Widget) : Void
    {
        __setSpecialStyleWhenDisabled(widget);

        super.apply(widget);
    }


    /**
     * Define skins
     */
    private function __defineSkins () : Void
    {
        var map = [
            SKIN_PRIMARY_HOVER => COLOR_TURQUOISE_LIGHT,
            SKIN_PRIMARY       => COLOR_TURQUOISE,
            SKIN_PRIMARY_DOWN  => COLOR_GREEN_SEA,

            SKIN_WARNING_HOVER => COLOR_SUN_FLOWER_LIGHT,
            SKIN_WARNING       => COLOR_SUN_FLOWER,
            SKIN_WARNING_DOWN  => COLOR_ORANGE,

            SKIN_SILVER_HOVER => COLOR_SILVER_LIGHT,
            SKIN_SILVER       => COLOR_SILVER,
            SKIN_SILVER_DOWN  => COLOR_SILVER_DARK,

            SKIN_DANGER_HOVER => COLOR_ALIZARIN_LIGHT,
            SKIN_DANGER       => COLOR_ALIZARIN,
            SKIN_DANGER_DOWN  => COLOR_POMEGRANATE,

            SKIN_SUCCESS_HOVER => COLOR_EMERALD_LIGHT,
            SKIN_SUCCESS       => COLOR_EMERALD,
            SKIN_SUCCESS_DOWN  => COLOR_NEPHRITIS,

            SKIN_INVERSE_HOVER => COLOR_WET_ASPHALT_LIGHT,
            SKIN_INVERSE       => COLOR_WET_ASPHALT,
            SKIN_INVERSE_DOWN  => COLOR_MIDNIGHT_BLUE,

            SKIN_INFO_HOVER => COLOR_PETER_RIVER_LIGHT,
            SKIN_INFO       => COLOR_PETER_RIVER,
            SKIN_INFO_DOWN  => COLOR_BELIZE_HOLE,

            SKIN_DISABLED   => COLOR_CONCRETE,
            SKIN_ASBESTOS   => COLOR_ASBESTOS,
            SKIN_BACKGROUND => COLOR_CLOUDS_DARK
        ];
        var color;
        for (skinName in map.keys()) {
            color = map.get(skinName);
            Sx.registerSkin(skinName, skinGenerator.bind(color));
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
        SliderStyle.defineStyles(this);
        CheckBoxStyle.defineStyles(this);
        RadioStyle.defineStyles(this);
        TabBarStyle.defineStyles(this);
        TabButtonStyle.defineStyles(this);
    }


    /**
     * Returns callback which creates PaintSkin with specified `color`
     */
    public function skinGenerator (color:Int) : PaintSkin
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


    /**
     * Set grayscale mode for disabled widgets if backend supports it.
     */
    private inline function __setSpecialStyleWhenDisabled (widget:Widget) : Void
    {
        widget.onDisable.add(onDisable);
        widget.onEnable.add(onEnable);

        if (!widget.enabled) onDisable(widget);
    }

}//class FlatUITheme