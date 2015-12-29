package sx.widgets.special;

import sx.properties.ButtonState;
import sx.properties.metric.Size;
import sx.properties.metric.Units;
import sx.widgets.Button;
import sx.widgets.Widget;





/**
 * Buttons as items for typed lists
 *
 */
class ButtonListItem extends ListItem<Button>
{

    /**
     * Update item state
     */
    override public function refresh () : Void
    {
        __releaseButton();
        __hookButton();

        data.text = 'item $dataIndex';

        width.dip  = data.width.dip;
        height.dip = data.height.dip;
    }


    /**
     * Remove signal listeners from button on this item
     */
    private function __releaseButton () : Void
    {
        while (numChildren > 0) {
            removeChildAt(0).onResize.remove(__buttonResized);
        }
    }


    /**
     * Attach signal listeners to button on this item
     */
    private function __hookButton () : Void
    {
        if (data == null) return null;

        data.onResize.add(__buttonResized);
        addChild(data);
    }


    /**
     * Button on this item was resized
     */
    private function __buttonResized (button:Widget, size:Size, previousUnits:Units, previousValue:Float) : Void
    {
        width.dip  = data.width.dip;
        height.dip = data.height.dip;
    }

}//class ButtonListItem<T>