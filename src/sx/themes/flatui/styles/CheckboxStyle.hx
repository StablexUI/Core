package sx.themes.flatui.styles;

import sx.layout.Layout;
import sx.properties.Align;
import sx.properties.Orientation;
import sx.themes.flatui.Icons;
import sx.themes.FlatUITheme;
import sx.themes.Theme;
import sx.widgets.Button;
import sx.widgets.Checkbox;
import sx.widgets.HBox;
import sx.widgets.ToggleButton;
import sx.widgets.Widget;
import sx.layout.LineLayout;

using sx.Sx;



/**
 * Defines styles for buttons in HaxeTheme
 *
 */
class CheckboxStyle
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
        Theme.DEFAULT_STYLE => [FlatUITheme.SKIN_SILVER, FlatUITheme.SKIN_PRIMARY_DOWN],
        WARNING  => [FlatUITheme.SKIN_SILVER, FlatUITheme.SKIN_WARNING_DOWN],
        SILVER   => [FlatUITheme.SKIN_SILVER, FlatUITheme.SKIN_ASBESTOS],
        DANGER   => [FlatUITheme.SKIN_SILVER, FlatUITheme.SKIN_DANGER_DOWN],
        SUCCESS  => [FlatUITheme.SKIN_SILVER, FlatUITheme.SKIN_SUCCESS_DOWN],
        INVERSE  => [FlatUITheme.SKIN_SILVER, FlatUITheme.SKIN_INVERSE_DOWN],
        INFO     => [FlatUITheme.SKIN_SILVER, FlatUITheme.SKIN_INFO_DOWN],
        DISABLED => [FlatUITheme.SKIN_DISABLED, FlatUITheme.SKIN_DISABLED]
    ];


    /**
     * Set button styles
     */
    @:noCompletion
    static public inline function defineStyles (theme:FlatUITheme) : Void
    {
        var skins;
        var fn;
        for (style in __styleSkins.keys()) {
            skins = __styleSkins.get(style);
            fn = template.bind(_, skins[0], skins[1]);
            theme.styles(Checkbox).set(style, fn);
        }
    }


    static public function template (widget:Widget, upSkin:String, downSkin:String) : Void
    {
        var check = __common(cast widget);

        #if stablexui_flash
            check.backend.buttonMode    = true;
            check.backend.mouseChildren = false;
            check.backend.mouseEnabled  = check.enabled;
            check.onDisable.add(__onDisableFlash);
            check.onEnable.add(__onEnableFlash);
        #end

        check.up.ico    = __createIco(upSkin, false);
        check.hover.ico = __createIco(upSkin, true);
        check.down.ico  = __createIco(downSkin, true);
    }


    /**
     * Common  part of all styles
     */
    static private inline function __common (check:Checkbox) : Checkbox
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
     * Create an icon for single state of Checkbox
     */
    static private function __createIco (skin:String, addGlyph:Bool) : Widget
    {
        var ico = new HBox();
        ico.width.dip  = FlatUITheme.DEFAULT_ICO_SIZE;
        ico.height.dip = FlatUITheme.DEFAULT_ICO_SIZE;
        ico.skin       = skin;

        if (addGlyph) {
            var glyph = Icons.checkSquare(FlatUITheme.FONT_SIZE_BIG);
            ico.addChild(glyph);
        }

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


}//class CheckboxStyle