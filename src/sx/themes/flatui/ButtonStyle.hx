package sx.themes.flatui;

import sx.layout.Layout;
import sx.properties.Align;
import sx.properties.Orientation;
import sx.themes.FlatUITheme;
import sx.themes.Theme;
import sx.widgets.Button;
import sx.widgets.Widget;
import sx.layout.LineLayout;

using sx.Sx;



/**
 * Defines styles for buttons in HaxeTheme
 *
 */
class ButtonStyle
{
    static public inline var WARNING  = 'warningButton';
    static public inline var DANGER   = 'dangerButton';
    static public inline var CONCRETE = 'concreteButton';
    static public inline var SUCCESS  = 'successButton';
    static public inline var INVERSE  = 'inverseButton';
    static public inline var INFO     = 'infoButton';
    static public inline var DISABLED = 'disabledButton';

    /** Which skins to use for each style */
    static private var __styleSkins = [
        Theme.DEFAULT_STYLE => [FlatUITheme.SKIN_PRIMARY, FlatUITheme.SKIN_PRIMARY_DOWN],
        WARNING  => [FlatUITheme.SKIN_WARNING, FlatUITheme.SKIN_WARNING_DOWN],
        CONCRETE => [FlatUITheme.SKIN_CONCRETE, FlatUITheme.SKIN_CONCRETE_DOWN],
        DANGER   => [FlatUITheme.SKIN_DANGER, FlatUITheme.SKIN_DANGER_DOWN],
        SUCCESS  => [FlatUITheme.SKIN_SUCCESS, FlatUITheme.SKIN_SUCCESS_DOWN],
        INVERSE  => [FlatUITheme.SKIN_INVERSE, FlatUITheme.SKIN_INVERSE_DOWN],
        INFO     => [FlatUITheme.SKIN_INFO, FlatUITheme.SKIN_INFO_DOWN],
        DISABLED => [FlatUITheme.SKIN_DISABLED, FlatUITheme.SKIN_DISABLED]
    ];


    /**
     * Set button styles
     */
    @:noCompletion
    static public inline function defineStyles (theme:FlatUITheme) : Void
    {
        var skins;
        for (style in __styleSkins.keys()) {
            skins = __styleSkins.get(style);
            theme.styles(Button).set(style, template.bind(_, skins[0], skins[1]));
        }
    }


    static public function template (widget:Widget, upSkin:String, downSkin:String) : Void
    {
        var button = __common(cast widget);

        button.up.skin   = upSkin;
        button.down.skin = downSkin;
    }


    /**
     * Common  part of all styles
     */
    static private inline function __common (button:Button) : Button
    {
        var fontSize = FlatUITheme.FONT_SIZE.toPx();
        var format   = FlatUITheme.textFormat(fontSize, FlatUITheme.FONT_COLOR);
        button.label.setTextFormat(format);

        button.width.dip  = FlatUITheme.DEFAULT_WIDTH;
        button.height.dip = FlatUITheme.DEFAULT_HEIGHT;

        button.layout = __layout();

        return button;
    }


    /**
     * Create default layout
     */
    static private inline function __layout () : Layout
    {
        var layout = new LineLayout(Horizontal);
        layout.autoSize.set(false, false);
        layout.align.set(Center, Middle);
        layout.padding.horizontal.dip = FlatUITheme.DEFAULT_PADDING_HORIZONTAL;
        layout.padding.vertical.dip   = FlatUITheme.DEFAULT_PADDING_VERTICAL;
        layout.gap.dip                = FlatUITheme.DEFAULT_GAP;

        return layout;
    }

}//class ButtonStyle