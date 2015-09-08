package sx.backend;

import sx.widgets.Widget;



/**
 * Backend factory interface
 *
 */
interface IBackend
{

    /**
     * Get "global" stage instance which can be useg for popups, tooltips etc.
     */
    public function getGlobalStage () : IStage ;

    /**
     * Create display object for `widget`
     */
    public function createDisplay (widget:Widget) : IDisplay ;

}//interface IBackend