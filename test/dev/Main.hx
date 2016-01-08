package ;

import sx.flatui.FlatUITheme;
import sx.flatui.ScrollBarStyle;
import sx.layout.LineLayout;
import sx.skins.PaintSkin;
import sx.skins.Skin;
import sx.Sx;
import sx.widgets.Button;
import sx.widgets.special.ButtonListItem;
import sx.widgets.Widget;
import sx.widgets.ScrollList;


/**
 * Description
 *
 */
class Main
{
static public var FLAG = false;
    /**
     * Description
     */
    static public function main () : Void
    {
        Sx.pixelSnapping = true;
        Sx.theme = new FlatUITheme();
        Sx.init(run);
    }


    /**
     * Description
     */
    static private function run () : Void
    {
        var skinFactory  = function (color:Int) : Skin {
            var skin = new PaintSkin();
            skin.color = color;
            return skin;
        }

        var list = new ScrollList<Button>();
        list.skin = skinFactory(0x00FF00);
        list.itemClass = ButtonListItem;
        list.verticalBar.style = ScrollBarStyle.VERTICAL;
        list.verticalBar.right = 2;
        list.horizontalBar = null;//.bottom = 2;

        list.width = 200;
        list.height = 420;

        Sx.root.addChild(list);

        var btn;
        list.data = [for (i in 0...100) {
            btn = new Button();
            btn.text = 'Item $i';
            btn;
        }];
FLAG = true;

    }

}//class Main