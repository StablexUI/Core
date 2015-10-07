package sx.widgets;

import sx.properties.Orientation;



/**
 * Box widget with `orientation = Horizontal` by default
 *
 */
class HBox extends Box
{

    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        orientation = Horizontal;
    }

}//class HBox