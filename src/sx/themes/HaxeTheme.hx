package sx.themes;

import sx.layout.LineLayout;
import sx.skins.ASkin;
import sx.skins.PaintSkin;
import sx.skins.Skin;
import sx.widgets.Widget;
import sx.Sx;
import sx.widgets.Button;


@:enum
abstract Colors (Int) to Int
{
    var COLOR_ORANGE       = 0xEA8220;
    var COLOR_WHITE        = 0xFFFFFF;
    var COLOR_YELLOW       = 0xFBC707;
    var COLOR_DARK_RED     = 0xA84B38;
    var COLOR_ALMOST_BLACK = 0x141419;
}


@:enum
abstract Skins (String) to String
{
    var SKIN_ORANGE       = 'orange';
    var SKIN_WHITE        = 'white';
    var SKIN_YELLOW       = 'yellow';
    var SKIN_DARK_RED     = 'darkRed';
    var SKIN_ALMOST_BLACK = 'almostBlack';

    @:to private function toASkin () : ASkin return Sx.skin(this);
}


/**
 * This theme is inspired by Haxe branding.
 *
 * @link http://haxe.org/foundation/branding.html
 */
class HaxeTheme extends Theme
{

    /**
     * Initialize theme styles
     */
    override private function initialize () : Void
    {
        __defineSkins();
        __defineStyles();
        finalize();
    }


    /**
     * Define skins
     */
    private function __defineSkins () : Void
    {
        var map = [
            SKIN_ORANGE       => COLOR_ORANGE,
            SKIN_WHITE        => COLOR_WHITE,
            SKIN_YELLOW       => COLOR_YELLOW,
            SKIN_DARK_RED     => COLOR_DARK_RED,
            SKIN_ALMOST_BLACK => COLOR_ALMOST_BLACK
        ];

        var color;
        for (skinName in map.keys()) {
            color = map.get(skinName);
            Sx.registerSkin(skinName, __skinGenerator.bind(color));
        }
    }


    /**
     * Define styles
     */
    private function __defineStyles () : Void
    {
        styles(Button).set(Theme.DEFAULT_STYLE, __buttonDefault);
    }


    /**
     * Returns callback which creates PaintSkin with specified `color`
     */
    private function __skinGenerator (color:Colors) : Skin
    {
        var skin = new PaintSkin();
        skin.color = color;

        return skin;
    }


    /**
     * Default button style
     */
    private function __buttonDefault (widget:Widget) : Void
    {
        var button : Button = cast widget;

        var layout : LineLayout = cast button.layout;
        layout.gap.dip = 5;

        button.width.dip  = 100;
        button.height.dip = 30;

        button.up.skin    = SKIN_ORANGE;
        button.hover.skin = SKIN_YELLOW;
        button.down.skin  = SKIN_DARK_RED;
    }

}//class HaxeTheme