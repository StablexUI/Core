package sx.backend.flash;

import flash.events.Event;
import flash.Lib;
import sx.backend.flash.Display;
import sx.backend.flash.Stage;
import sx.widgets.Widget;



/**
 * Flash backend based on display objects
 *
 */
class Backend implements IBackend
{
    /** If `Sx.render()` updates started */
    static private var renderingStarted : Bool = false;

    /** Stage instance for `Sx.stage` */
    private var globalStage : Stage;


    /**
     * Constructor
     */
    public function new () : Void
    {
        if (!renderingStarted) {
            Lib.current.stage.addEventListener(Event.ENTER_FRAME, renderFrame);
            renderingStarted = true;
        }
    }


    /**
     * Get "global" stage instance which can be useв for popups, tooltips etc.
     */
    public function getGlobalStage () : IStage
    {
        if (globalStage == null) {
            globalStage = new Stage(Lib.current.stage);
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
    static private function renderFrame (e:Event) : Void
    {
        Sx.render();
    }

}//class Backend