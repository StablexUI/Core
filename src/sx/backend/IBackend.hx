package sx.backend;

import sx.widgets.Widget;



/**
 * Backend factory interface
 *
 */
interface IBackend
{
    /**
     * Set `stage` as global stage instance which will be used by `Sx.stage`
     */
    public function setGlobalStage (stage:IStage) : Void ;

    /**
     * Get "global" stage instance which can be useg for popups, tooltips etc.
     */
    public function getGlobalStage () : IStage ;

    /**
     * Create display object for `widget`
     */
    public function createDisplay (widget:Widget) : IDisplay ;

}//interface IBackend