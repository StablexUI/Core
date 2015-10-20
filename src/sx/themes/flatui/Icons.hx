package sx.themes.flatui;

import sx.themes.FlatUITheme;
import sx.widgets.Text;


/**
 * Icons factory
 *
 */
class Icons
{
    /** Unicodes for glyphs in icons font */
    static private inline var GLYPH_CHECK        = 0xF00C;
    static private inline var GLYPH_DOT_CIRCLE_O = 0x192;
    static private inline var GLYPH_CIRCLE     = 0xF111;
    static private inline var GLYPH_CIRCLE_O     = 0xF10C;
    static private inline var GLYPH_CHECK_SQUARE = 0xF14A;


    /**
     * Creats an icon widget with specified glyph
     *
     * @param   size       Glyph size in DIPs. By default uses `FlatUITheme.FONT_SIZE`
     * @param   color      Glyph color. By default: `FlatUITheme.FONT_COLOR_LIGHT`
     */
    static public function check (size:Int = -1, color:Int = -1) return FlatUITheme.icon(GLYPH_CHECK, size, color);
    static public function dotCircleO (size:Int = -1, color:Int = -1) return FlatUITheme.icon(GLYPH_DOT_CIRCLE_O, size, color);
    static public function circleO (size:Int = -1, color:Int = -1) return FlatUITheme.icon(GLYPH_CIRCLE_O, size, color);
    static public function circle (size:Int = -1, color:Int = -1) return FlatUITheme.icon(GLYPH_CIRCLE, size, color);
    static public function checkSquare (size:Int = -1, color:Int = -1) return FlatUITheme.icon(GLYPH_CHECK_SQUARE, size, color);


}//class Icons