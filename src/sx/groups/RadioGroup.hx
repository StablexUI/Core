package sx.groups;

import sx.signals.Signal;
import sx.widgets.Radio;
import sx.widgets.ToggleButton;


/**
 * Objects which manage selection of two or more `Radio` widgets
 *
 */
class RadioGroup
{
    /** Get currently selected option */
    public var selected (default,null) : Null<Radio>;

    /** Dispatched when selection changed */
    public var onChange (get,never) : Signal<RadioGroup->Void>;
    private var __onChange : Signal<RadioGroup->Void>;

    /** Widgets in group */
    private var __options : Array<Radio>;
    /** If currently iteration over __options to update selection */
    private var __updatingSelection : Bool = false;


    /**
     * Constructor
     */
    public function new () : Void
    {
        __options = [];
    }


    /**
     * Add option to this groups
     */
    public function add (radio:Radio) : Void
    {
        if (__options.indexOf(radio) >= 0) return;

        __options.push(radio);
        __hook(radio);
        radio.group = this;

        if (radio.selected) __updateSelection(radio);
    }


    /**
     * Remove option from this group
     */
    public function remove (radio:Radio) : Void
    {
        if (!__options.remove(radio)) return;

        __release(radio);
        radio.group = null;
    }


    /**
     * Add signal listeners
     */
    private function __hook (radio:Radio) : Void
    {
        radio.onToggle.add(__optionToggled);
    }


    /**
     * Remove signal listeners
     */
    private function __release (radio:Radio) : Void
    {
        radio.onToggle.remove(__optionToggled);

        if (selected == radio) {
            selected = null;
            __onChange.dispatch(this);
        }
    }


    /**
     * Remove old selection
     */
    private function __updateSelection (toggled:Radio) : Void
    {
        if (__updatingSelection) return;
        __updatingSelection = true;

        //deselect currently selected option
        if (selected == toggled) {
            if (!toggled.selected) {
                selected = null;
                __onChange.dispatch(this);
            }

        //selected another option
        } else if (toggled.selected) {
            selected = toggled;

            for (radio in __options) {
                if (radio != toggled) {
                    radio.selected = false;
                }
            }

            __onChange.dispatch(this);
        }

        __updatingSelection = false;
    }


    /**
     * Selected some another option
     */
    private function __optionToggled (toggle:ToggleButton) : Void
    {
        __updateSelection(cast toggle);
    }


    /** Typical signal getters */
    private function get_onChange ()            return (__onChange == null ? __onChange = new Signal() : __onChange);


}//class RadioGroup