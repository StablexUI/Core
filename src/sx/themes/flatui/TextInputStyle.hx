package sx.themes.flatui;

import sx.layout.Layout;
import sx.properties.Align;
import sx.properties.Orientation;
import sx.themes.FlatUITheme;
import sx.themes.Theme;
import sx.widgets.TextInput;
import sx.widgets.Widget;
import sx.layout.LineLayout;

using sx.Sx;



/**
 * Defines styles for buttons in HaxeTheme
 *
 */
class TextInputStyle
{
    static public inline var ERROR   = 'errorInput';
    static public inline var SUCCESS = 'successInput';

    /** Which skins to use for each style */
    static private var __styles = [
        Theme.DEFAULT_STYLE => {skin:FlatUITheme.SKIN_INPUT_DEFAULT, fontColor:FlatUITheme.COLOR_WET_ASPHALT, bold:false},
        SUCCESS             => {skin:FlatUITheme.SKIN_INPUT_SUCCESS, fontColor:FlatUITheme.COLOR_EMERALD, bold:true},
        ERROR               => {skin:FlatUITheme.SKIN_INPUT_ERROR, fontColor:FlatUITheme.COLOR_ALIZARIN, bold:true}
    ];


    /**
     * Set input field styles
     */
    @:noCompletion
    static public inline function defineStyles (theme:FlatUITheme) : Void
    {
        var cfg;
        for (style in __styles.keys()) {
            cfg = __styles.get(style);
            theme.styles(TextInput).set(style, template.bind(_, cfg));
        }
    }


    static public function template (widget:Widget, cfg:{skin:String, fontColor:Int, bold:Bool}) : Void
    {
        var input = __common(cast widget);
        __setTextFormat(input, cfg.fontColor, cfg.bold);
        input.skin = cfg.skin;
    }


    /**
     * Common  part of all styles
     */
    static private inline function __common (input:TextInput) : TextInput
    {
        input.padding.horizontal.dip = FlatUITheme.DEFAULT_PADDING_HORIZONTAL;
        input.padding.horizontal.dip = FlatUITheme.DEFAULT_PADDING_VERTICAL;
        input.width.dip  = FlatUITheme.DEFAULT_WIDTH;
        input.height.dip = FlatUITheme.DEFAULT_HEIGHT;

        return input;
    }


    /**
     * Setup text formatting options
     */
    static private inline function __setTextFormat (input:TextInput, color:Int, bold:Bool) : Void
    {
        var fontSize = FlatUITheme.FONT_SIZE.toPx();
        var format   = FlatUITheme.textFormat(fontSize, color, bold);
        input.setTextFormat(format);
    }


}//class TextInputStyle