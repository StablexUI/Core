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
    static public inline var VERTICAL          = 'verticalSlider';
    static public inline var WARNING           = 'warningSlider';
    static public inline var WARNING_VERTICAL  = 'vertical_warningSlider';
    static public inline var SILVER            = 'silverSlider';
    static public inline var SILVER_VERTICAL   = 'vertical_silverSlider';
    static public inline var DANGER            = 'dangerSlider';
    static public inline var DANGER_VERTICAL   = 'vertical_dangerSlider';
    static public inline var SUCCESS           = 'successSlider';
    static public inline var SUCCESS_VERTICAL  = 'vertical_successSlider';
    static public inline var INVERSE           = 'inverseSlider';
    static public inline var INVERSE_VERTICAL  = 'vertical_inverseSlider';
    static public inline var INFO              = 'infoSlider';
    static public inline var INFO_VERTICAL     = 'vertical_infoSlider';
    static public inline var DISABLED          = 'disabledSlider';
    static public inline var DISABLED_VERTICAL = 'vertical_disabledSlider';

    /** Default height for bar */
    static public inline var DEFAULT_SIZE = 8;

    /** Which thumb styles to use for each style */
    static private var __horizontalThumbStyles = [
        Theme.DEFAULT_STYLE => Theme.DEFAULT_STYLE,
        WARNING             => ScrollBarStyle.WARNING,
        SILVER              => ScrollBarStyle.SILVER,
        DANGER              => ScrollBarStyle.DANGER,
        SUCCESS             => ScrollBarStyle.SUCCESS,
        INVERSE             => ScrollBarStyle.INVERSE,
        INFO                => ScrollBarStyle.INFO,
        DISABLED            => ScrollBarStyle.DISABLED,
    ];
    static private var __verticalThumbStyles = [
        VERTICAL          => Theme.DEFAULT_STYLE,
        WARNING_VERTICAL  => ScrollBarStyle.WARNING,
        SILVER_VERTICAL   => ScrollBarStyle.SILVER,
        DANGER_VERTICAL   => ScrollBarStyle.DANGER,
        SUCCESS_VERTICAL  => ScrollBarStyle.SUCCESS,
        INVERSE_VERTICAL  => ScrollBarStyle.INVERSE,
        INFO_VERTICAL     => ScrollBarStyle.INFO,
        DISABLED_VERTICAL => ScrollBarStyle.DISABLED,
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

        bar.easing     = Quad.easeOut;
        bar.width.dip  = DEFAULT_SIZE;
        bar.height.pct = 100;

        var thumb = new Button();
        thumb.style = thumbStyle;
        thumb.style = null;
        thumb.releaseOnPointerOut = false;
        thumb.up.skin = thumb.down.skin;
        thumb.width.dip = DEFAULT_SIZE;

        bar.thumb = thumb;
    }


}//class ScrollBarStyle