package sx.themes.flatui.styles;

import sx.themes.FlatUITheme;
import sx.widgets.TabBar;
import sx.widgets.Widget;
import sx.properties.Align;



/**
 * Style for tab bars
 *
 */
class TabBarStyle
{

    /**
     * Define styles for TabBar
     */
    static public function defineStyles (theme:FlatUITheme) : Void
    {
        theme.styles(TabBar).set(Theme.DEFAULT_STYLE, __defaultStyle);
    }


    /**
     * Default style
     */
    static private function __defaultStyle (widget:Widget) : Void
    {
        var bar : TabBar = cast widget;

        bar.skin = FlatUITheme.SKIN_INVERSE_HOVER;
        bar.align.set(Left, Middle);
        bar.padding.vertical.dip   = 0;
        bar.padding.horizontal.dip = FlatUITheme.DEFAULT_PADDING_HORIZONTAL;
        bar.width.pct  = 100;
        bar.height.dip = FlatUITheme.GREATER_HEIGHT;
    }

}//class TabBarStyle