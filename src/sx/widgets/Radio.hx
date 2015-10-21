package sx.widgets;

import sx.groups.RadioGroup;
import sx.widgets.ToggleButton;


/**
 * Ordinary radio control
 *
 */
class Radio extends ToggleButton
{

    /** Group this option belongs to */
    public var group (default,set) : RadioGroup;


    /**
     * Setter `group`
     */
    private function set_group (value:RadioGroup) : RadioGroup
    {
        if (group != value) {
            if (group != null) group.removeRadio(this);

            group = value;

            if (value != null) group.addRadio(this);
        }

        return value;
    }


    /**
     * Setter `selected`
     */
    override private function set_selected (value:Bool) : Bool
    {
        if (!value && group != null && group.selected == this) {
            return value;
        }

        return super.set_selected(value);
    }

}//class Radio