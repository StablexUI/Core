package sx.widgets;

import sx.properties.metric.Size;
import sx.properties.metric.Units;
import sx.widgets.Widget;



/**
 * Widget, which scales his first added child so that child size fits parents size.
 *
 * Always maintains child's aspect ratio.
 * Child is always centered when adjusting scaling.
 *
 * If you want your UI to be automatically scaled to fit stage size when stage resized, then use this snippet:
 * ```
 * var fit = new ScaleFit();
 * fit.width.pct = 100;
 * fit.height.pct = 100;
 * Sx.root.addChild(fit);
 *
 * var uiRoot = new Widget();
 * uiRoot.width = 800;  //game width
 * uiRoot.height = 600; //game height
 * fit.addChild(uiRoot);
 *
 * Sx.root = uiRoot;
 *
 * //from this point you can add your UI to Sx.root
 * //...
 * ```
 */
class ScaleFit extends Widget
{
    /** Scaled child */
    private var __child : Widget;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        onResize.add(__scaleFitResized);
        onChildAdded.add(__childAdded);
        onChildRemoved.add(__childRemoved);
    }


    /**
     * Adjust child scaling to the size of this widget.
     */
    public function adjustScaling () : Void
    {
        if (__child == null) return;

        __child.offset.set(-0.5, -0.5);
        __child.origin.set(0.5, 0.5);

        var scale = Math.min(width.dip / __child.width.dip, height.dip / __child.height.dip);
        __child.scaleX = scale;
        __child.scaleY = scale;

        __child.left.pct = 50;
        __child.top.pct  = 50;
    }


    /**
     * Method to cleanup and release this object for garbage collector.
     */
    override public function dispose (recursive:Bool = true) : Void
    {
        __releaseChild(__child);
        __child = null;

        super.dispose();
    }


    /**
     * This widget resized, adjust child scale
     */
    private function __scaleFitResized (me:Widget, size:Size, prevUnits:Units, prevValue:Float) : Void
    {
        adjustScaling();
    }


    /**
     * Description
     */
    private function __childAdded (me:Widget, child:Widget, index:Int) : Void
    {
        if (__child == null) {
            __child = child;
            __hookChild(child);
            adjustScaling();
        }
    }


    /**
     * Description
     */
    private function __childRemoved (me:Widget, child:Widget, index:Int) : Void
    {
        if (__child == child) {
            __child = null;
            __releaseChild(child);
        }
    }


    /**
     * Listen for `child` signals
     */
    private function __hookChild (child:Widget) : Void
    {
        child.onDispose.add(__childDisposed);
        child.onResize.add(__childResized);
    }


    /**
     * Stop listening to `child` signals
     */
    private function __releaseChild (child:Widget) : Void
    {
        child.onDispose.remove(__childDisposed);
        child.onResize.remove(__childResized);
    }


    /**
     * Release child if it's being disposed
     */
    private function __childDisposed (child:Widget) : Void
    {
        if (__child == child) {
            __child = null;
        }
        __releaseChild(child);
    }


    /**
     * Adjust scaling if child size changed
     */
    private function __childResized (child:Widget, size:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (__child == child) {
            adjustScaling();
        }
    }


}//class Icon