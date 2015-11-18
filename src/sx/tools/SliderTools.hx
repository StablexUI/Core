package sx.tools;

import sx.input.Pointer;
import sx.properties.Orientation;
import sx.widgets.Slider;

using sx.Sx;
using sx.tools.WidgetTools;


/**
 * Utilities for `sx.widgets.Slider`
 *
 */
class SliderTools
{

    /**
     * Get coordinate on slider (in DIPs) which reflects current `slider.value`
     */
    static public function getValueCoordinateDip (slider:Slider) : Float
    {
        var sliderSize = slider.size(slider.orientation);
        var thumbSize  = slider.thumb.size(slider.orientation);

        var part = (slider.max > slider.min ? (slider.value - slider.min) / (slider.max - slider.min) : 1);
        var min  = thumbSize.dip * 0.5;
        var max  = sliderSize.dip - 0.5 * thumbSize.dip;
        var pos  = min + part * (max - min) - 0.5 * thumbSize.dip;

        return pos;
    }


    /**
     * Calculate possible slider value under current pointer position
     */
    static public function pointerPosToValue (slider:Slider, shiftX:Float = 0, shiftY:Float = 0) : Float
    {
        var pos = slider.globalToLocal(Pointer.getPosition());

        var thumbSize  = slider.thumb.size(slider.orientation);
        var sliderSize = slider.size(slider.orientation);

        var max  = sliderSize.dip - thumbSize.dip;
        //prevent division by zero
        if (max == 0) max = 0.001;

        var part = 1.0;
        switch (slider.orientation) {
            case Horizontal:
                var x = pos.x.toDip() + shiftX;
                if (slider.thumb.left.selected) {
                    part =  x / max;
                } else {
                    part = (max - x) / max;
                }
            case Vertical:
                var y = pos.y.toDip() + shiftY;
                if (slider.thumb.top.selected) {
                    part =  y / max;
                } else {
                    part = (max - y) / max;
                }
        }

        var value = slider.min + part * (slider.max - slider.min);
        if (value < slider.min) {
            value = slider.min;
        } else if (value > slider.max) {
            value = slider.max;
        }

        return value;
    }

}//class SliderTools