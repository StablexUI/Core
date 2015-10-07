package sx.widgets;

import sx.properties.Orientation;
import sx.widgets.base.Box;



/**
 * Box widget with `orientation = Vertical` by default
 *
 */
class VBox extends Box
{

    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        orientation = Vertical;
    }

}//class VBox