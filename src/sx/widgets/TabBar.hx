package sx.widgets;

import sx.exceptions.InvalidArgumentException;
import sx.groups.RadioGroup;
import sx.signals.Signal;
import sx.themes.Theme;
import sx.widgets.TabButton;


/**
 * A bar with toggle buttons, which can have only one button toggled at a time.
 *
 * Only `TabButton` widgets can be added to
 */
class TabBar extends Box
{
    /** Currently selected tab */
    public var selected (get,never) : Null<TabButton>;
    /** Style used for new tabs created via `createTab()` */
    public var tabStyle : String = Theme.DEFAULT_STYLE;

    /** Dispatched when selection changed */
    public var onChange (get,never) : Signal<TabBar->Void>;
    private var __onChange : Signal<TabBar->Void>;

    /** Group which controls tabs selection */
    private var __tabsGroup : RadioGroup;



    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        __tabsGroup = new RadioGroup();

        onChildAdded.add(__childAdded);
        onChildRemoved.add(__childRemoved);

        __tabsGroup.onChange.add(__tabSelected);
    }


    /**
     * If no tab selected, select first one after initialization.
     */
    override public function initialize () : Void
    {
        super.initialize();

        if (__tabsGroup.selected == null && numChildren > 0) {
            getTabAt(0).selected = true;
        }
    }


    /**
     * Create a tab and use `title` as label.
     *
     * Returns created tab.
     */
    public function createTab (title:String) : TabButton
    {
        var tab = new TabButton();
        tab.style = tabStyle;
        tab.text = title;

        addChild(tab);

        return tab;
    }


    /**
     * Search `TabButton` instances in display list and return them.
     */
    public function getTabs () : Array<TabButton>
    {
        var tabs : Array<TabButton> = [];

        var child;
        for (i in 0...numChildren) {
            child = getChildAt(i);
            if (Std.is(child, TabButton)) {
                tabs.push(cast child);
            }
        }

        return tabs;
    }


    /**
     * Check every added child is TabButton
     */
    private function __childAdded (me:Widget, child:Widget, index:Int) : Void
    {
        if (!Std.is(child, TabButton)) return;

        var tab : TabButton = cast child;
        tab.group = __tabsGroup;
    }


    /**
     * Check every removed child and if it's a tab, perform some cleaning
     */
    private function __childRemoved (me:Widget, child:Widget, index:Int) : Void
    {
        if (!Std.is(child, TabButton)) return;

        var tab : TabButton = cast child;
        if (tab.group == __tabsGroup) {
            tab.group = null;
        }
    }


    /**
     * User selected another tab
     */
    private function __tabSelected (tabsGroup:RadioGroup) : Void
    {
        __onChange.dispatch(this);
    }

    /**
     * Getter `selected`
     */
    private function get_selected () : TabButton
    {
        return (__tabsGroup.selected == null ? null : cast __tabsGroup.selected);
    }


    /** Typical signal getters */
    private function get_onChange ()            return (__onChange == null ? __onChange = new Signal() : __onChange);

}//class TabBar