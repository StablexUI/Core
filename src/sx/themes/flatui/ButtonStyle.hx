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
    static public inline var SILVER   = 'silverButton';
    static public inline var SUCCESS  = 'successButton';
    static public inline var INVERSE  = 'inverseButton';
    static public inline var INFO     = 'infoButton';
    static public inline var DISABLED = 'disabledButton';

    /** Which skins to use for each style */
    static private var __styleSkins = [
        Theme.DEFAULT_STYLE => [FlatUITheme.SKIN_PRIMARY_HOVER, FlatUITheme.SKIN_PRIMARY, FlatUITheme.SKIN_PRIMARY_DOWN],
        WARNING  => [FlatUITheme.SKIN_WARNING_HOVER, FlatUITheme.SKIN_WARNING, FlatUITheme.SKIN_WARNING_DOWN],
        SILVER   => [FlatUITheme.SKIN_SILVER_HOVER, FlatUITheme.SKIN_SILVER, FlatUITheme.SKIN_SILVER_DOWN],
        DANGER   => [FlatUITheme.SKIN_DANGER_HOVER, FlatUITheme.SKIN_DANGER, FlatUITheme.SKIN_DANGER_DOWN],
        SUCCESS  => [FlatUITheme.SKIN_SUCCESS_HOVER, FlatUITheme.SKIN_SUCCESS, FlatUITheme.SKIN_SUCCESS_DOWN],
        INVERSE  => [FlatUITheme.SKIN_INVERSE_HOVER, FlatUITheme.SKIN_INVERSE, FlatUITheme.SKIN_INVERSE_DOWN],
        INFO     => [FlatUITheme.SKIN_INFO_HOVER, FlatUITheme.SKIN_INFO, FlatUITheme.SKIN_INFO_DOWN],
        DISABLED => [FlatUITheme.SKIN_DISABLED, FlatUITheme.SKIN_DISABLED, FlatUITheme.SKIN_DISABLED]
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
            theme.styles(Button).set(style, template.bind(_, skins[0], skins[1], skins[2]));
        }
    }


    static public function template (widget:Widget, hoverSkin:String, upSkin:String, downSkin:String) : Void
    {
        var button = __common(cast widget);

        #if stablexui_flash
            button.backend.buttonMode    = true;
            button.backend.mouseChildren = false;
            button.backend.mouseEnabled  = button.enabled;
            button.onDisable.add(__onDisableFlash);
            button.onEnable.add(__onEnableFlash);
        #end

        button.hover.skin = hoverSkin;
        button.up.skin    = upSkin;
        button.down.skin  = downSkin;
    }


    /**
     * Common  part of all styles
     */
    static private inline function __common (button:Button) : Button
    {
        var fontSize = FlatUITheme.FONT_SIZE.toPx();
        var format   = FlatUITheme.textFormat(fontSize, FlatUITheme.FONT_COLOR_LIGHT, true);
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

#if stablexui_flash

    /**
     * Callback to invoke when button disabled (for stablexui-flash backend)
     */
    static private function __onDisableFlash (w:Widget) : Void
    {
        w.backend.mouseEnabled = false;
    }

    /**
     * Callback to invoke when button enabled (for stablexui-flash backend)
     */
    static private function __onEnableFlash (w:Widget) : Void
    {
        w.backend.mouseEnabled = true;
    }

#end


}//class ButtonStyle