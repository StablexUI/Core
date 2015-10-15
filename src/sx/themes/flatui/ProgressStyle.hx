package sx.themes.flatui;

import sx.themes.FlatUITheme;
import sx.themes.Theme;
import sx.widgets.Progress;
import sx.widgets.Widget;



/**
 * Styles for `Progress` widget
 *
 */
class ProgressStyle
{
    /** Default height for progress bars */
    static public inline var DEFAULT_HEIGHT = 12;

    /**
     * Set button styles
     */
    @:noCompletion
    static public inline function defineStyles (theme:FlatUITheme) : Void
    {
        theme.styles(Progress).set(Theme.DEFAULT_STYLE, __defaultStyle);
    }


    /**
     * Default style
     */
    static private function __defaultStyle (widget:Widget) : Void
    {
        var progress : Progress = cast widget;

        progress.width.dip  = FlatUITheme.DEFAULT_WIDTH;
        progress.height.dip = DEFAULT_HEIGHT;
        progress.skin       = FlatUITheme.SKIN_BACKGROUND;
        progress.bar.skin   = FlatUITheme.SKIN_PRIMARY;
    }

}//class ProgressStyle