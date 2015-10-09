package sx.themes.haxe;

import sx.properties.Align;
import sx.properties.Orientation;
import sx.themes.HaxeTheme;
import sx.widgets.Button;
import sx.widgets.Widget;
import sx.layout.LineLayout;



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

        var layout = new LineLayout(Horizontal);
        layout.autoSize.set(true, true);
        layout.align.set(Center, Middle);
        layout.padding.vertical.dip   = 5;
        layout.padding.horizontal.dip = 20;
        layout.gap.dip = 5;
        button.layout  = layout;

        button.up.skin    = SKIN_ORANGE;
        button.hover.skin = SKIN_YELLOW;
        button.down.skin  = SKIN_DARK_RED;

        button.onPress.add(__pressed);
        button.onRelease.add(__released);
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
    private function __pressed (button:Button) : Void
    {
        // button.offset.top.dip = 1;
        button.scaleX = button.scaleY = 0.95;
    }


    /**
     * Signal listener for releasing button
     */
    private function __released (button:Button) : Void
    {
        // button.offset.top.dip = 0;
        button.scaleX = button.scaleY = 1;
    }

}//class ButtonStyles