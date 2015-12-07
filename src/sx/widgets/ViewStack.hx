package sx.widgets;

import sx.signals.Signal;
import sx.transitions.Transition;
import sx.widgets.Widget;



/**
 * A set of some views (e.g. screens).
 *
 * There can be only one child element visible in ViewStack at a moment.
 * By default visible child is one with childIndex = 0
 *
 */
class ViewStack extends Widget
{

    /** Currently visible child */
    public var current (default,null) : Null<Widget>;
    /** Currently visible child index. Returns `0` if this `ViewStack` has no children. */
    public var currentIndex (get,never) : Int;
    /** wrap the stack list or not (for `.next()` and `.previous()` calls) */
    public var wrap : Bool = false;
    /** Transition effect to play when changing active view */
    public var transition : Null<Transition>;

    /** Dispatched when viewstack changes views. */
    public var onChange (get,never) : Signal<ViewStack->Void>;
    private var __onChange : Signal<ViewStack->Void>;

    /** History of shown views */
    private var __history : Array<Widget>;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        __history = [];
        onChildAdded.add(__childAdded);
        onChildRemoved.add(__childRemoved);
    }


    /**
     * Show element with given child `index`.
     *
     * If specified `index` does not exist, does nothing.
     *
     * @param index
     * @param onComplete    Callback to invoke when transition finished.
     */
    public function showIndex (index:Int, onComplete:Void->Void = null) : Void
    {
        __change(getChildAt(index), onComplete);
    }


    /**
     * Show child with specified `name`.
     *
     * Does nothing if no children with `name` exist.
     *
     * @param index
     * @param onComplete    Callback to invoke when transition finished.
     */
    public function show (name:String, onComplete:Void->Void = null) : Void
    {
        __change(getDirectChild(name), onComplete);
    }


    /**
     * Show element wich was shown previously.
     * Goes back through history log and removes the last entry from log.
     *
     * @param onComplete    Callback to invoke when transition finished.
     */
    public inline function back (onComplete:Void->Void = null) : Void
    {
        if (canBack()) {
            var toShow = __history.pop();
            __change(toShow, onComplete, true, true);
        }
    }


    /**
     * Indicates if there is some history of showing views.
     *
     * If this method returns `false` then `.back()` has no effect.
     */
    public function canBack () : Bool
    {
        return __history.length > 0;
    }


    /**
     * Show next element in display list of viewstack.
     * If `viewStack.wrap` is `true` and we are at the end of the stack then show the first one.
     *
     * @param onComplete    Callback to invoke when transition finished.
     */
    public function next (onComplete:Void->Void = null) : Void
    {
        var index = (current == null ? 0 : getChildIndex(current) + 1);
        if (index >= numChildren) {
            if (wrap) {
                index = 0;
            } else {
                return;
            }
        }

        showIndex(index, onComplete);
    }


    /**
     * Show previous element in display list of viewstack.
     * If `viewStack.wrap` is `true` and we are at the beginning of the stack then show the last one.
     *
     * @param onComplete    Callback to invoke when transition finished.
     */
    public function previous (onComplete:Void->Void = null) : Void
    {
        var index = (current == null ? 0 : getChildIndex(current) - 1);
        if (index < 0 && !wrap) {
            return;
        }

        showIndex(index, onComplete);
    }


    /**
     * Hide current widget and show `toShow` widget.
     */
    private function __change (toShow:Null<Widget>, onComplete:Void->Void = null, ignoreHistory:Bool = false, reverseTransition:Bool = false) : Void
    {
        if (toShow == null) return;

        if (toShow == current) {
            if (onComplete != null) {
                onComplete();
            }

            return;
        }

        var toHide = current;
        current    = toShow;

        if (!ignoreHistory) {
            __history.push(toHide);
        }

        if (transition == null) {
            toHide.visible = false;
            toShow.visible = true;
            if (onComplete != null) {
                onComplete();
            }

        } else {
            if (reverseTransition) {
                transition.reverse(toHide, toShow, onComplete);
            } else {
                transition.change(toHide, toShow, onComplete);
            }
        }

        __onChange.dispatch(this);
    }


    /**
     * Called when new child added
     */
    private function __childAdded (me:Widget, child:Widget) : Void
    {
        if (numChildren == 1) {
            child.visible = true;
            current = child;
        } else {
            child.visible = false;
        }
    }


    /*
     * Called when new child removed
     */
    private function __childRemoved (me:Widget, child:Widget) : Void
    {
        if (child == current) {
            current = null;
        }

        var removed : Bool;
        do {
            removed = __history.remove(child);
        } while (removed);
    }


    /**
     * Getter for `currentIndex`
     */
    private function get_currentIndex () : Int
    {
        if (current != null) {
            return getChildIndex(current);
        }

        return 0;
    }


    /** Signal getters */
    private function get_onChange ()      return (__onChange == null ? __onChange = new Signal() : __onChange);

}//class ViewStack