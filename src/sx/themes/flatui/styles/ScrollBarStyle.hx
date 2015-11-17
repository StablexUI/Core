package sx.themes.flatui.styles;

import sx.properties.Orientation;
import sx.skins.ASkin;
import sx.skins.PaintSkin;
import sx.skins.Skin;
import sx.themes.FlatUITheme;
import sx.themes.Theme;
import sx.tween.easing.Quad;
import sx.widgets.ScrollBar;
import sx.widgets.Widget;
import sx.widgets.Button;



/**
 * Styles for `ScrollBar` widget
 *
 */
class ScrollBarStyle
{
    /** Style names */
    static public inline var VERTICAL          = 'verticalScrollBar';
    static public inline var WARNING           = 'warningScrollBar';
    static public inline var WARNING_VERTICAL  = 'vertical_warningScrollBar';
    static public inline var SILVER            = 'silverScrollBar';
    static public inline var SILVER_VERTICAL   = 'vertical_silverScrollBar';
    static public inline var DANGER            = 'dangerScrollBar';
    static public inline var DANGER_VERTICAL   = 'vertical_dangerScrollBar';
    static public inline var SUCCESS           = 'successScrollBar';
    static public inline var SUCCESS_VERTICAL  = 'vertical_successScrollBar';
    static public inline var INVERSE           = 'inverseScrollBar';
    static public inline var INVERSE_VERTICAL  = 'vertical_inverseScrollBar';
    static public inline var INFO              = 'infoScrollBar';
    static public inline var INFO_VERTICAL     = 'vertical_infoScrollBar';
    static public inline var DISABLED          = 'disabledScrollBar';
    static public inline var DISABLED_VERTICAL = 'vertical_disabledScrollBar';

    /** Default height for bar */
    static public inline var DEFAULT_SIZE = 8;

    /** Which thumb styles to use for each style */
    static private var __horizontalThumbStyles = [
        Theme.DEFAULT_STYLE => Theme.DEFAULT_STYLE,
        WARNING             => ButtonStyle.WARNING,
        SILVER              => ButtonStyle.SILVER,
        DANGER              => ButtonStyle.DANGER,
        SUCCESS             => ButtonStyle.SUCCESS,
        INVERSE             => ButtonStyle.INVERSE,
        INFO                => ButtonStyle.INFO,
        DISABLED            => ButtonStyle.DISABLED,
    ];
    static private var __verticalThumbStyles = [
        VERTICAL          => Theme.DEFAULT_STYLE,
        WARNING_VERTICAL  => ButtonStyle.WARNING,
        SILVER_VERTICAL   => ButtonStyle.SILVER,
        DANGER_VERTICAL   => ButtonStyle.DANGER,
        SUCCESS_VERTICAL  => ButtonStyle.SUCCESS,
        INVERSE_VERTICAL  => ButtonStyle.INVERSE,
        INFO_VERTICAL     => ButtonStyle.INFO,
        DISABLED_VERTICAL => ButtonStyle.DISABLED,
    ];

    /**
     * Set styles
     */
    @:noCompletion
    static public inline function defineStyles (theme:FlatUITheme) : Void
    {
        var thumbStyle;
        for (style in __horizontalThumbStyles.keys()) {
            thumbStyle = __horizontalThumbStyles.get(style);
            theme.styles(ScrollBar).set(style, __horizontal.bind(_, thumbStyle));
        }
        for (style in __verticalThumbStyles.keys()) {
            thumbStyle = __verticalThumbStyles.get(style);
            theme.styles(ScrollBar).set(style, __vertical.bind(_, thumbStyle));
        }
    }


    /**
     * Horizontal
     */
    static private function __horizontal (widget:Widget, thumbStyle:String) : Void
    {
        var bar : ScrollBar = cast widget;
        bar.easing     = Quad.easeOut;
        bar.width.pct  = 100;
        bar.height.dip = DEFAULT_SIZE;

        var thumb = new Button();
        thumb.style = thumbStyle;
        thumb.style = null;
        thumb.releaseOnPointerOut = false;
        thumb.up.skin = thumb.down.skin;
        thumb.height.dip = DEFAULT_SIZE;

        bar.thumb = thumb;
    }


    /**
     * Vertical
     */
    static private function __vertical (widget:Widget, thumbStyle:String) : Void
    {
        var bar : ScrollBar = cast widget;
        bar.orientation = Vertical;
        bar.easing      = Quad.easeOut;
        bar.width.dip   = DEFAULT_SIZE;
        bar.height.pct  = 100;

        var thumb = new Button();
        thumb.style = thumbStyle;
        thumb.style = null;
        thumb.releaseOnPointerOut = false;
        thumb.up.skin = thumb.down.skin;
        thumb.width.dip = DEFAULT_SIZE;

        bar.thumb = thumb;
    }


}//class ScrollBarStyle