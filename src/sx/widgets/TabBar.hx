package sx.widgets;

import sx.exceptions.InvalidArgumentException;
import sx.groups.RadioGroup;
import sx.signals.Signal;
import sx.themes.Theme;
import sx.widgets.base.Box;
import sx.widgets.TabButton;
import sx.properties.Orientation;
import sx.widgets.ViewStack;


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

    /**
     * Tabs in this bar will switch views in `viewStack`.
     *
     * First tab will show the first view, seconds tab - second view, etc.
     * If amount of tabs is greater than amount of views, then excess tabs will not do anything.
     * If amount of views is greater than amount of tabs, then excess views cannot not be shown by this tab bar.
     */
    public var viewStack : Null<ViewStack>;

    /** Group which controls tabs selection */
    private var __tabsGroup : RadioGroup;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        orientation = Horizontal;

        __tabsGroup = new RadioGroup();

        onChildAdded.add(__childAdded);
        onChildRemoved.add(__childRemoved);

        __tabsGroup.onChange.add(__tabSelected);
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

        if (selected == null) {
            tab.selected = true;
        }
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
        if (__tabsGroup.selected != null) {
            if (viewStack != null) {
                var tabIndex = -1;
                var child;
                for (i in 0...numChildren) {
                    child = getChildAt(i);
                    if (Std.is(child, TabButton)) {
                        tabIndex ++;
                    }
                    if (child == __tabsGroup.selected) {
                        break;
                    }
                }

                if (tabIndex >= 0) {
                    viewStack.showIndex(tabIndex);
                }
            }
        }

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