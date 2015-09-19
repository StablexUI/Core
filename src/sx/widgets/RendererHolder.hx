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
    public var __renderer (get,never) : Renderer;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        autoSize = new AutoSize(true);
        autoSize.onChange = __autoSizeChanged;

        __createRenderer();

        __renderer.onResize(__rendererResized);
    }


    /**
     * Method to cleanup and release this object for garbage collector.
     */
    override public function dispose (disposeChildren:Bool = true) : Void
    {
        super.dispose(disposeChildren);

        __renderer.dispose();
    }


    /**
     * Creates renderer for native content.
     *
     * Override in descendants.
     */
    private function __createRenderer () : Void
    {

    }


    /**
     * Called when `autoSize` settings changed
     */
    private function __autoSizeChanged (widthChanged:Bool, heightChanged:Bool) : Void
    {
        if (widthChanged && autoSize.width) {
            width.px = __renderer.getWidth();
        }
        if (heightChanged && autoSize.height) {
            height.px = __renderer.getHeight();
        }
    }


    /**
     * Callback for renderer to invoke when renderer's content resized.
     */
    private function __rendererResized (widthPx:Float, heightPx:Float) : Void
    {
        if (autoSize.width) width.px = widthPx;
        if (autoSize.height) height.px = heightPx;
    }


    /**
     * Getter for `renderer`.
     *
     * Override in descendants
     */
    private inline function get___renderer () : Renderer
    {
        return null;
    }

}//class RendererHolder