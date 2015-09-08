package sx.backend.dummy;

import sx.backend.IBackend;



/**
 * Dummy backend
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
            globalStage = new Stage();
        }

        return globalStage;
    }


    /**
     * Create display object for `widget`
     */
    public function createDisplay (widget:Widget) : IDisplay
    {
        return new Display();
    }

}//class Backend