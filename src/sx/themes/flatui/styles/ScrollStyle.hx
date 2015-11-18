package sx.themes.flatui.styles;

import sx.themes.FlatUITheme;
import sx.themes.Theme;
import sx.widgets.Scroll;
import sx.widgets.ScrollBar;
import sx.widgets.Widget;



/**
 * Styles for `Scroll` widget
 *
 */
class ScrollStyle
{

    /**
     * Set styles
     */
    @:noCompletion
    static public inline function defineStyles (theme:FlatUITheme) : Void
    {
        theme.styles(Scroll).set(Theme.DEFAULT_STYLE, __default);
    }


    /**
     * Default style
     */
    static private function __default (widget:Widget) : Void
    {
        var scroll : Scroll = cast widget;

        scroll.horizontalBar = new ScrollBar();
        scroll.horizontalBar.bottom.dip = 2;
        scroll.verticalBar = new ScrollBar();
        scroll.verticalBar.style = ScrollBarStyle.VERTICAL;
        scroll.verticalBar.right.dip = 2;
    }


}//class ScrollStyle