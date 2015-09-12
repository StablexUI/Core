package sx.backend.flash;

import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.Lib;
import sx.backend.flash.Display;
import sx.backend.IStage;



/**
 * Stage implementation
 *
 */
class GlobalStage extends Stage
{
    /**
     * Cosntructor
     */
    public function new () : Void
    {
        super(Lib.current.stage);

        Lib.current.stage.addEventListener(Event.RESIZE, stageResized);
    }


    /**
     * Return display index at which first widget in stage's display list should be rendered.
     */
    override public function getFirstDisplayIndex () : Int
    {
        var child;
        for (i in 0...container.numChildren) {
            child = container.getChildAt(i);

            //start when first widget reached
            if (Std.is(child, Display)) {
                return i;
            }
        }

        //no widgets on stage yet, add them to the end of display list
        return container.numChildren - 1;
    }


    /**
     * Remove all excess children after last rendered widget.
     *
     * @param freeDisplayIndex    Next display index after last widget rendered on this stage.
     */
    override public function finalizeRender (freeDisplayIndex:Int) : Void
    {
        var child;
        for (i in freeDisplayIndex...container.numChildren) {
            child = container.getChildAt(freeDisplayIndex);

            //remove outdated widgets displays
            if (Std.is(child, Display)) {
                container.removeChild(child);

            //once non-widget display objects reached, stop iterating
            } else {
                return;
            }
        }
    }


    /**
     * Clean before releasing for GC
     */
    override public function dispose () : Void
    {
        super.dispose();
        Lib.current.stage.removeEventListener(Event.RESIZE, stageResized);
    }


    /**
     * When native stage resized
     */
    private function stageResized (e:Event) : Void
    {
        width.px  = Lib.current.stage.stageWidth;
        height.px = Lib.current.stage.stageHeight;
    }

}//class Stage