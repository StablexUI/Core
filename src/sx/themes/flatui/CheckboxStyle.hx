package sx.themes.flatui;

import sx.layout.Layout;
import sx.properties.Align;
import sx.properties.Orientation;
import sx.themes.FlatUITheme;
import sx.themes.Theme;
import sx.widgets.Button;
import sx.widgets.Checkbox;
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
        Theme.DEFAULT_STYLE => [FlatUITheme.SKIN_DISABLED, FlatUITheme.SKIN_PRIMARY_DOWN],
        WARNING  => [FlatUITheme.SKIN_DISABLED, FlatUITheme.SKIN_WARNING_DOWN],
        SILVER   => [FlatUITheme.SKIN_DISABLED, FlatUITheme.SKIN_SILVER_DOWN],
        DANGER   => [FlatUITheme.SKIN_DISABLED, FlatUITheme.SKIN_DANGER_DOWN],
        SUCCESS  => [FlatUITheme.SKIN_DISABLED, FlatUITheme.SKIN_SUCCESS_DOWN],
        INVERSE  => [FlatUITheme.SKIN_DISABLED, FlatUITheme.SKIN_INVERSE_DOWN],
        INFO     => [FlatUITheme.SKIN_DISABLED, FlatUITheme.SKIN_INFO_DOWN],
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

        check.up.ico.width.dip = FlatUITheme.DEFAULT_ICO_SIZE;
        check.up.ico.height.dip = FlatUITheme.DEFAULT_ICO_SIZE;
        check.down.ico.width.dip = FlatUITheme.DEFAULT_ICO_SIZE;
        check.down.ico.height.dip = FlatUITheme.DEFAULT_ICO_SIZE;

        check.up.ico.skin    = upSkin;
        check.down.ico.skin  = downSkin;
    }


    /**
     * Common  part of all styles
     */
    static private inline function __common (check:Checkbox) : Checkbox
    {
        var fontSize = FlatUITheme.FONT_SIZE.toPx();
        var format   = FlatUITheme.textFormat(fontSize, FlatUITheme.FONT_COLOR_DARK, true);
        check.label.setTextFormat(format);

        // check.width.dip  = FlatUITheme.DEFAULT_WIDTH;
        // check.height.dip = FlatUITheme.DEFAULT_HEIGHT;

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
        // layout.padding.horizontal.dip = FlatUITheme.DEFAULT_PADDING_HORIZONTAL;
        // layout.padding.vertical.dip   = FlatUITheme.DEFAULT_PADDING_VERTICAL;
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


}//class CheckboxStyle