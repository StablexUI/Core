package sx.widgets;

import sx.properties.ButtonState;
import sx.signals.Signal;


/**
 * Simple toggleable button.
 *
 */
class ToggleButton extends Button
{
    /** Determines if button is currently selected (pressed and left in down state) */
    public var selected (get,set) : Bool;
    private var __selected : Bool = false;


    /** Dispatched when `toggleButton.selected` changes */
    public var onToggle (get,never) : Signal<ToggleButton->Void>;
    private var __onToggle : Signal<ToggleButton->Void>;


    /**
     * Dispatch `onTrigger` signal
     */
    override public function trigger () : Void
    {
        selected = !selected;
        super.trigger();
    }


    /**
     * Set current button state
     */
    override public function setState (state:ButtonState) : Void
    {
        if (selected) state = down;
        super.setState(state);
    }


    /**
     * Setter `selected`
     */
    private function set_selected (value:Bool) : Bool
    {
        if (__selected != value) {
            __selected = value;

            if (__selected) {
                setState(down);
            } else {
                if (__pressed) {
                    setState(down);
                } else if (__hovered) {
                    setState(__hover);
                } else {
                    setState(__up);
                }
            }

            __onToggle.dispatch(this);
        }

        return value;
    }


    /** Getters */
    private function get_selected ()    return __selected;


    /** Signal getters */
    private function get_onToggle ()      return (__onToggle == null ? __onToggle = new Signal() : __onToggle);


}//class ToggleButton