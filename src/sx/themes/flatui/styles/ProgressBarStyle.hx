package sx.themes.flatui.styles;

import sx.properties.Orientation;
import sx.themes.FlatUITheme;
import sx.themes.Theme;
import sx.tween.easing.Quad;
import sx.widgets.ProgressBar;
import sx.widgets.Widget;



/**
 * Styles for `ProgressBar` widget
 *
 */
class ProgressBarStyle
{
    /** Style names */
    static public inline var VERTICAL         = 'verticalProgressBar';
    static public inline var WARNING          = 'warningProgressBar';
    static public inline var WARNING_VERTICAL = 'vertical_warningProgressBar';
    static public inline var SILVER           = 'silverProgressBar';
    static public inline var SILVER_VERTICAL  = 'vertical_silverProgressBar';
    static public inline var DANGER           = 'dangerProgressBar';
    static public inline var DANGER_VERTICAL  = 'vertical_dangerProgressBar';
    static public inline var SUCCESS          = 'successProgressBar';
    static public inline var SUCCESS_VERTICAL = 'vertical_successProgressBar';
    static public inline var INVERSE          = 'inverseProgressBar';
    static public inline var INVERSE_VERTICAL = 'vertical_inverseProgressBar';
    static public inline var INFO             = 'infoProgressBar';
    static public inline var INFO_VERTICAL    = 'vertical_infoProgressBar';

    /** Default height for progress bars */
    static public inline var DEFAULT_HEIGHT = 12;

    /** Which skins to use for each style */
    static private var __horizontalStyleSkins = [
        Theme.DEFAULT_STYLE => FlatUITheme.SKIN_PRIMARY,
        WARNING             => FlatUITheme.SKIN_WARNING,
        SILVER              => FlatUITheme.SKIN_SILVER,
        DANGER              => FlatUITheme.SKIN_DANGER,
        SUCCESS             => FlatUITheme.SKIN_SUCCESS,
        INVERSE             => FlatUITheme.SKIN_INVERSE,
        INFO                => FlatUITheme.SKIN_INFO,
    ];
    static private var __verticalStyleSkins = [
        VERTICAL         => FlatUITheme.SKIN_PRIMARY,
        WARNING_VERTICAL => FlatUITheme.SKIN_WARNING,
        SILVER_VERTICAL  => FlatUITheme.SKIN_SILVER,
        DANGER_VERTICAL  => FlatUITheme.SKIN_DANGER,
        SUCCESS_VERTICAL => FlatUITheme.SKIN_SUCCESS,
        INVERSE_VERTICAL => FlatUITheme.SKIN_INVERSE,
        INFO_VERTICAL    => FlatUITheme.SKIN_INFO,
    ];

    /**
     * Set button styles
     */
    @:noCompletion
    static public inline function defineStyles (theme:FlatUITheme) : Void
    {
        var skin;
        for (style in __horizontalStyleSkins.keys()) {
            skin = __horizontalStyleSkins.get(style);
            theme.styles(ProgressBar).set(style, __horizontal.bind(_, skin));
        }
        for (style in __verticalStyleSkins.keys()) {
            skin = __verticalStyleSkins.get(style);
            theme.styles(ProgressBar).set(style, __vertical.bind(_, skin));
        }
    }


    /**
     * Default style
     */
    static private function __horizontal (widget:Widget, barSkin:String) : Void
    {
        var progress : ProgressBar = cast widget;

        progress.easing     = Quad.easeOut;
        progress.width.dip  = FlatUITheme.DEFAULT_WIDTH;
        progress.height.dip = DEFAULT_HEIGHT;
        progress.skin       = FlatUITheme.SKIN_BACKGROUND;
        progress.bar.skin   = barSkin;
    }


    /**
     * Vertical progress bar
     */
    static private function __vertical (widget:Widget, barSkin:String) : Void
    {
        var progress : ProgressBar = cast widget;

        progress.easing      = Quad.easeOut;
        progress.orientation = Vertical;
        progress.width.dip   = DEFAULT_HEIGHT;
        progress.height.dip  = FlatUITheme.DEFAULT_WIDTH;
        progress.skin        = FlatUITheme.SKIN_BACKGROUND;
        progress.bar.skin    = barSkin;
        progress.bar.bottom.select();
    }

}//class ProgressBarStyle