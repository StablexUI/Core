package sx.themes.flatui.styles;

import sx.layout.Layout;
import sx.properties.Align;
import sx.properties.Orientation;
import sx.themes.FlatUITheme;
import sx.themes.Theme;
import sx.widgets.Button;
import sx.widgets.Radio;
import sx.widgets.HBox;
import sx.widgets.ToggleButton;
import sx.widgets.Widget;
import sx.layout.LineLayout;

using sx.Sx;



/**
 * Defines styles for buttons in HaxeTheme
 *
 */
class RadioStyle
{
    static public inline var WARNING  = 'warningRadio';
    static public inline var DANGER   = 'dangerRadio';
    static public inline var SILVER   = 'silverRadio';
    static public inline var SUCCESS  = 'successRadio';
    static public inline var INVERSE  = 'inverseRadio';
    static public inline var INFO     = 'infoRadio';
    static public inline var DISABLED = 'disabledRadio';

    /** Which skins to use for each style */
    static private var __styleSkins = [
        Theme.DEFAULT_STYLE => [FlatUITheme.COLOR_SILVER, FlatUITheme.COLOR_TURQUOISE],
        WARNING  => [FlatUITheme.COLOR_SILVER, FlatUITheme.COLOR_SUN_FLOWER],
        SILVER   => [FlatUITheme.COLOR_SILVER, FlatUITheme.COLOR_ASBESTOS],
        DANGER   => [FlatUITheme.COLOR_SILVER, FlatUITheme.COLOR_ALIZARIN],
        SUCCESS  => [FlatUITheme.COLOR_SILVER, FlatUITheme.COLOR_EMERALD],
        INVERSE  => [FlatUITheme.COLOR_SILVER, FlatUITheme.COLOR_WET_ASPHALT],
        INFO     => [FlatUITheme.COLOR_SILVER, FlatUITheme.COLOR_PETER_RIVER],
        DISABLED => [FlatUITheme.COLOR_CONCRETE, FlatUITheme.COLOR_CONCRETE]
    ];


    /**
     * Set button styles
     */
    @:noCompletion
    static public inline function defineStyles (theme:FlatUITheme) : Void
    {
        var colors;
        var fn;
        for (style in __styleSkins.keys()) {
            colors = __styleSkins.get(style);
            fn = template.bind(_, colors[0], colors[1]);
            theme.styles(Radio).set(style, fn);
        }
    }


    static public function template (widget:Widget, unselectedColor:Int, selectedColor:Int) : Void
    {
        var radio = __common(cast widget);

        #if stablexui_flash
            radio.backend.buttonMode    = true;
            radio.backend.mouseChildren = false;
            radio.backend.mouseEnabled  = radio.enabled;
            radio.onDisable.add(__onDisableFlash);
            radio.onEnable.add(__onEnableFlash);
        #end

        radio.up.ico    = Icons.radioUnchecked(-1, unselectedColor);
        radio.hover.ico = Icons.radioChecked(-1, unselectedColor);
        radio.down.ico  = Icons.radioChecked(-1, selectedColor);
    }


    /**
     * Common  part of all styles
     */
    static private inline function __common (radio:Radio) : Radio
    {
        var fontSize = FlatUITheme.FONT_SIZE.toPx();
        var format   = FlatUITheme.textFormat(fontSize, FlatUITheme.FONT_COLOR_DARK, false);
        radio.label.setTextFormat(format);

        radio.layout = __layout();

        return radio;
    }


    /**
     * Create default layout
     */
    static private inline function __layout () : Layout
    {
        var layout = new LineLayout(Horizontal);
        layout.autoSize.set(true, true);
        layout.align.set(Center, Middle);
        layout.gap.dip = FlatUITheme.DEFAULT_GAP * 0.5;

        return layout;
    }


    /**
     * Create an icon for single state of Radio
     */
    static private function __createIco (pic:Widget) : Widget
    {
        var ico = new HBox();
        ico.width.dip  = FlatUITheme.DEFAULT_ICO_SIZE;
        ico.height.dip = FlatUITheme.DEFAULT_ICO_SIZE;

        ico.addChild(pic);

        return ico;
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


}//class RadioStyle