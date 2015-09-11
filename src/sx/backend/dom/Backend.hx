package sx.backend.dom;

import js.Browser;
import sx.backend.dom.Display;
import sx.widgets.Widget;



/**
 * Html DOM backend factory
 *
 */
class Backend implements IBackend
{
    /** Stage instance for `Sx.stage` */
    private var globalStage : Stage;


    /**
     * Constructor
     */
    public function new () : Void
    {
        Browser.window.requestAnimationFrame(renderFrame);
    }


    /**
     * Get "global" stage instance which can be useв for popups, tooltips etc.
     */
    public function getGlobalStage () : IStage
    {
        if (globalStage == null) {
            globalStage = new Stage(Browser.document.body);
        }

        return globalStage;
    }


    /**
     * Create display object for `widget`
     */
    public function createDisplay (widget:Widget) : IDisplay
    {
        return new Display(widget);
    }


    /**
     * Render current stage of widgets attached to stages
     */
    private function renderFrame (time:Float) : Void
    {
        Browser.window.requestAnimationFrame(renderFrame);
        Sx.render();
    }

}//class Backend