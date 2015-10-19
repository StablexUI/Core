package sx.widgets;


/**
 * Simple toggleable button.
 *
 */
class ToggleButton extends Button
{
    /** Determines if button is currently selected (pressed and left in down state) */
    public var selected (get,set) : Bool;
    private var __selected : Bool = false;




    /** Getters */
    private function get_selected ()    return __selected;

}//class ToggleButton