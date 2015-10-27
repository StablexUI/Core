package sx.widgets;

import sx.exceptions.InvalidArgumentException;
import sx.groups.RadioGroup;
import sx.themes.Theme;
import sx.widgets.TabButton;


/**
 * A bar with toggle buttons, which can have only one button toggled at a time.
 *
 * Only `TabButton` widgets can be added to
 */
class TabBar extends Box
{

    /** Style used for new tabs created via `createTab()` */
    public var tabStyle : String = Theme.DEFAULT_STYLE;

    /** Group which controls tabs selection */
    private var __tabsGroup : RadioGroup;



    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        __tabs = [];
        __tabsGroup = new RadioGroup();

        onChildAdded.add(__childAdded);
        onChildRemoved.add(__childRemoved);
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
     * Check every added child is TabButton
     */
    private function __childAdded (me:Widget, child:Widget, index:Int) : Void
    {
        if (!Std.is(child, TabButton)) {
            throw new InvalidArgumentException('Only `TabButton` widgets can be added to `TabBar`');
        }

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

}//class TabBar