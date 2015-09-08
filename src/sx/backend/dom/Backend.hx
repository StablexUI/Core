package sx.backend.dom;

import js.Browser;



/**
 * Html DOM backend factory
 *
 */
class Backend extends IBackend
{
    /** Stage instance for `Sx.stage` */
    private var globalStage : Stage;


    /**
     * Constructor
     */
    public function new () : Void
    {

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
        return null;
    }

}//class Backend