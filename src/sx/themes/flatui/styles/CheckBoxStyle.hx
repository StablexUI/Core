package sx.themes.flatui.styles;

import sx.layout.Layout;
import sx.properties.Align;
import sx.properties.Orientation;
import sx.themes.FlatUITheme;
import sx.themes.Theme;
import sx.widgets.Button;
import sx.widgets.CheckBox;
import sx.widgets.HBox;
import sx.widgets.ToggleButton;
import sx.widgets.Widget;
import sx.layout.LineLayout;

using sx.Sx;



/**
 * Defines styles for buttons in HaxeTheme
 *
 */
class CheckBoxStyle
{
    static public inline var WARNING  = 'warningCheckbox';
    static public inline var DANGER   = 'dangerCheckbox';
    static public inline var SILVER   = 'silverCheckbox';
    static public inline var SUCCESS  = 'successCheckbox';
    static public inline var INVERSE  = 'inverseCheckbox';
    static public inline var INFO     = 'infoCheckbox';
    static public inline var DISABLED = 'disabledCheckbox';

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
            theme.styles(CheckBox).set(style, fn);
        }
    }


    static public function template (widget:Widget, unselectedColor:Int, selectedColor:Int) : Void
    {
        var check = __common(cast widget);

        #if stablexui_flash
            check.backend.buttonMode    = true;
            check.backend.mouseChildren = false;
            check.backend.mouseEnabled  = check.enabled;
            check.onDisable.add(__onDisableFlash);
            check.onEnable.add(__onEnableFlash);
        #end

        check.up.ico    = Icons.checkboxUnchecked(-1, unselectedColor);
        check.hover.ico = Icons.checkboxChecked(-1, unselectedColor);
        check.down.ico  = Icons.checkboxChecked(-1, selectedColor);
    }


    /**
     * Common  part of all styles
     */
    static private inline function __common (check:CheckBox) : CheckBox
    {
        var fontSize = FlatUITheme.FONT_SIZE.toPx();
        var format   = FlatUITheme.textFormat(fontSize, FlatUITheme.FONT_COLOR_DARK, false);
        check.label.setTextFormat(format);

        check.layout = __layout();

        return check;
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


}//class CheckBoxStyle