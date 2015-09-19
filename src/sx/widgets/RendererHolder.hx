package sx.widgets;

import sx.backend.Renderer;
import sx.properties.AutoSize;
import sx.widgets.Widget;



/**
 * Base widget for various native renderers like texts and bitmaps.
 *
 * Do not instantiate this class directly, use derivatives.
 */
class RendererHolder extends Widget
{
    /** Settings for automatically adjusting widget size according to `renderer` size */
    public var autoSize (default,null) : AutoSize;

    /** native renderer */
    public var renderer (default,null) : Renderer;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        autoSize = new AutoSize(true);
        autoSize.onChange = __autoSizeChanged;
    }


    /**
     * Called when `autoSize` settings changed
     */
    private function __autoSizeChanged (widthChanged:Bool, heightChanged:Bool) : Void
    {

    }

}//class RendererHolder