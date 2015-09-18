package sx.widgets;

import sx.backend.Renderer;
import sx.widgets.Widget;



/**
 * Base widget for various native renderers like texts and bitmaps.
 *
 * Do not instantiate this class directly, use derivatives.
 */
class RendererHolder extends Widget
{

    /** native renderer */
    public var renderer (default,null) : Renderer;




}//class RendererHolder