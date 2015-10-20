package sx.themes.flatui.styles;

import sx.properties.Orientation;
import sx.skins.ASkin;
import sx.skins.PaintSkin;
import sx.themes.FlatUITheme;
import sx.themes.Theme;
import sx.tween.easing.Quad;
import sx.widgets.Slider;
import sx.widgets.Widget;
import sx.widgets.Button;



/**
 * Styles for `Slider` widget
 *
 */
class SliderStyle
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

    /** Default height for slider */
    static public inline var DEFAULT_HEIGHT = 12;
    /** Default size for thumb controls */
    static public inline var THUMB_SIZE = 20;

    /** Which thumb styles to use for each style */
    static private var __horizontalThumbStyles = [
        Theme.DEFAULT_STYLE => {thumb:Theme.DEFAULT_STYLE, fill:FlatUITheme.SKIN_PRIMARY},
        WARNING             => {thumb:ButtonStyle.WARNING, fill:FlatUITheme.SKIN_WARNING},
        SILVER            => {thumb:ButtonStyle.SILVER, fill:FlatUITheme.SKIN_SILVER},
        DANGER              => {thumb:ButtonStyle.DANGER, fill:FlatUITheme.SKIN_DANGER},
        SUCCESS             => {thumb:ButtonStyle.SUCCESS, fill:FlatUITheme.SKIN_SUCCESS},
        INVERSE             => {thumb:ButtonStyle.INVERSE, fill:FlatUITheme.SKIN_INVERSE},
        INFO                => {thumb:ButtonStyle.INFO, fill:FlatUITheme.SKIN_INFO},
        DISABLED            => {thumb:ButtonStyle.DISABLED, fill:FlatUITheme.SKIN_DISABLED},
    ];
    static private var __verticalThumbStyles = [
        VERTICAL          => {thumb:Theme.DEFAULT_STYLE, fill:FlatUITheme.SKIN_PRIMARY},
        WARNING_VERTICAL  => {thumb:ButtonStyle.WARNING, fill:FlatUITheme.SKIN_WARNING},
        SILVER_VERTICAL => {thumb:ButtonStyle.SILVER, fill:FlatUITheme.SKIN_SILVER},
        DANGER_VERTICAL   => {thumb:ButtonStyle.DANGER, fill:FlatUITheme.SKIN_DANGER},
        SUCCESS_VERTICAL  => {thumb:ButtonStyle.SUCCESS, fill:FlatUITheme.SKIN_SUCCESS},
        INVERSE_VERTICAL  => {thumb:ButtonStyle.INVERSE, fill:FlatUITheme.SKIN_INVERSE},
        INFO_VERTICAL     => {thumb:ButtonStyle.INFO, fill:FlatUITheme.SKIN_INFO},
        DISABLED_VERTICAL => {thumb:ButtonStyle.DISABLED, fill:FlatUITheme.SKIN_DISABLED},
    ];

    /**
     * Set button styles
     */
    @:noCompletion
    static public inline function defineStyles (theme:FlatUITheme) : Void
    {
        var thumbStyle;
        for (style in __horizontalThumbStyles.keys()) {
            thumbStyle = __horizontalThumbStyles.get(style);
            theme.styles(Slider).set(style, __horizontal.bind(_, thumbStyle));
        }
        for (style in __verticalThumbStyles.keys()) {
            thumbStyle = __verticalThumbStyles.get(style);
            theme.styles(Slider).set(style, __vertical.bind(_, thumbStyle));
        }
    }


    /**
     * Horizontal
     */
    static private function __horizontal (widget:Widget, style:{thumb:String,fill:String}) : Void
    {
        var slider : Slider = cast widget;

        slider.easing     = Quad.easeOut;
        slider.width.dip  = FlatUITheme.DEFAULT_WIDTH;
        slider.height.dip = DEFAULT_HEIGHT;
        slider.skin       = FlatUITheme.SKIN_BACKGROUND;

        slider.thumb.width.dip = DEFAULT_HEIGHT;
        slider.thumb.height.dip = DEFAULT_HEIGHT;

        var thumb = new Button();
        thumb.style = style.thumb;
        thumb.style = null;
        thumb.releaseOnPointerOut = false;
        thumb.up.skin = thumb.down.skin;
        thumb.width.dip  = THUMB_SIZE;
        thumb.height.dip = THUMB_SIZE;
        thumb.top.dip  = 0.5 * (DEFAULT_HEIGHT - THUMB_SIZE);
        thumb.left.dip = 0.5 * (DEFAULT_HEIGHT - THUMB_SIZE);

        cast(thumb.up.skin, PaintSkin).corners.pct = 50;
        cast(thumb.down.skin, PaintSkin).corners.pct = 50;
        cast(thumb.hover.skin, PaintSkin).corners.pct = 50;

        slider.thumb.addChild(thumb);

        var fill = new Widget();
        fill.height.dip = DEFAULT_HEIGHT;
        __adjustFill(slider, fill);
        fill.skin = style.fill;
        slider.thumb.onMove.add(function(w,s,u,v) __adjustFill(slider, fill));
        slider.addChildAt(fill, 0);
    }


    /**
     * Vertical slider
     */
    static private function __vertical (widget:Widget, style:{thumb:String,fill:String}) : Void
    {
        var slider : Slider = cast widget;

        slider.easing      = Quad.easeOut;
        slider.orientation = Vertical;
        slider.width.dip   = DEFAULT_HEIGHT;
        slider.height.dip  = FlatUITheme.DEFAULT_WIDTH;
        slider.skin        = FlatUITheme.SKIN_BACKGROUND;

        slider.thumb.width.dip = DEFAULT_HEIGHT;
        slider.thumb.height.dip = DEFAULT_HEIGHT;
        slider.thumb.bottom.select();

        var thumb = new Button();
        thumb.style = style.thumb;
        thumb.style = null;
        thumb.releaseOnPointerOut = false;
        thumb.up.skin = thumb.down.skin;
        thumb.width.dip  = THUMB_SIZE;
        thumb.height.dip = THUMB_SIZE;
        thumb.top.dip  = 0.5 * (DEFAULT_HEIGHT - THUMB_SIZE);
        thumb.left.dip = 0.5 * (DEFAULT_HEIGHT - THUMB_SIZE);

        cast(thumb.up.skin, PaintSkin).corners.pct = 50;
        cast(thumb.down.skin, PaintSkin).corners.pct = 50;
        cast(thumb.hover.skin, PaintSkin).corners.pct = 50;

        slider.thumb.addChild(thumb);

        var fill = new Widget();
        fill.width.dip = DEFAULT_HEIGHT;
        __adjustFill(slider, fill);
        fill.skin = style.fill;
        slider.thumb.onMove.add(function(w,s,u,v) __adjustFill(slider, fill));
        slider.addChildAt(fill, 0);
    }


    /**
     * Adjust `fill` size to current `silder.value`
     */
    static private inline function __adjustFill (slider:Slider, fill:Widget) : Void
    {
        switch (slider.orientation) {
            case Horizontal:
                if (slider.thumb.left.selected) {
                    fill.left.dip = 0;
                    fill.width.dip = slider.thumb.left.dip + DEFAULT_HEIGHT;
                } else {
                    fill.right.dip = 0;
                    fill.width.dip = slider.thumb.right.dip + DEFAULT_HEIGHT;
                }
            case Vertical:
                if (slider.thumb.top.selected) {
                    fill.top.dip = 0;
                    fill.height.dip = slider.thumb.top.dip + DEFAULT_HEIGHT;
                } else {
                    fill.bottom.dip = 0;
                    fill.height.dip = slider.thumb.bottom.dip + DEFAULT_HEIGHT;
                }
        }
    }

}//class SliderStyle