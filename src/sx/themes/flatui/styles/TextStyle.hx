package sx.themes.flatui.styles;

import sx.layout.Layout;
import sx.properties.Align;
import sx.properties.Orientation;
import sx.themes.FlatUITheme;
import sx.themes.Theme;
import sx.widgets.Text;
import sx.widgets.Widget;

using sx.Sx;



/**
 * Defines styles for ordinary texts
 *
 */
class TextStyle
{
    static public inline var ERROR   = 'errorText';
    static public inline var SUCCESS = 'successText';

    /** Which skins to use for each style */
    static private var __styles = [
        Theme.DEFAULT_STYLE => {fontColor:FlatUITheme.COLOR_WET_ASPHALT, bold:false},
        SUCCESS             => {fontColor:FlatUITheme.COLOR_EMERALD, bold:true},
        ERROR               => {fontColor:FlatUITheme.COLOR_ALIZARIN, bold:true}
    ];


    /**
     * Set text field styles
     */
    @:noCompletion
    static public inline function defineStyles (theme:FlatUITheme) : Void
    {
        var cfg;
        for (style in __styles.keys()) {
            cfg = __styles.get(style);
            theme.styles(Text).set(style, template.bind(_, cfg));
        }
    }


    static public function template (widget:Widget, cfg:{fontColor:Int, bold:Bool}) : Void
    {
        var txt : Text = cast widget;
        __setTextFormat(txt, cfg.fontColor, cfg.bold);
    }


    /**
     * Setup text formatting options
     */
    static private inline function __setTextFormat (txt:Text, color:Int, bold:Bool) : Void
    {
        var fontSize = FlatUITheme.FONT_SIZE.toPx();
        var format   = FlatUITheme.textFormat(fontSize, color, bold);
        txt.setTextFormat(format);
    }


}//class TextStyle