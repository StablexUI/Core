package sx.themes.haxe;

import sx.themes.HaxeTheme;
import sx.widgets.Button;
import sx.widgets.Widget;



/**
 * Defines styles for buttons in HaxeTheme
 *
 */
class ButtonStyles
{

    /**
     * Constructor
     */
    public function new () : Void
    {

    }


    public function defaultStyle (widget:Widget) : Void
    {
        var button = __cast(widget);

        var layout : LineLayout = cast button.layout;
        layout.gap.dip = 5;

        button.width.dip  = 100;
        button.height.dip = 30;

        button.up.skin    = SKIN_ORANGE;
        button.hover.skin = SKIN_YELLOW;
        button.down.skin  = SKIN_DARK_RED;
    }


    /**
     * Unsafe Widget to Button
     */
    private inline function __cast (widget:Widget) : Button
    {
        return cast widget;
    }


    /**
     * Signal listener for pressing button
     */
    private function __pressed (processor:Widget, dispatcher:Widget, touchId:Int) : Void
    {
        processor.offset.set(1, 1);
    }


    /**
     * Signal listener for releasing button
     */
    private function __released (processor:Widget, dispatcher:Widget, touchId:Int) : Void
    {
        processor.offset.set(1, 1);
    }

}//class ButtonStyles