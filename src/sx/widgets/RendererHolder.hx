package sx.widgets;

import sx.backend.Renderer;
import sx.properties.metric.Units;
import sx.properties.AutoSize;
import sx.properties.metric.Padding;
import sx.properties.metric.Size;
import sx.widgets.Widget;



/**
 * Base widget for various native renderers like texts and bitmaps.
 *
 * Do not instantiate this class directly, use derivatives.
 */
class RendererHolder extends Widget
{
    /**
     * Settings to automatically adjust widget size according to `renderer` size.
     * By default both `this.autoSize.width` and `this.autoSize.height` are `true`.
     *
     * Otherwise it's up to renderer to decide what to do: scale/resize content or do nothing.
     */
    public var autoSize (default,null) : AutoSize;
    /** Padding between widget borders and rendered content borders */
    public var padding (default,null) : Padding;

    /** native renderer */
    public var __renderer (get,never) : Renderer;
    /** Whether callback to invoke on renderer resizing is set */
    private var __rendererOnResizeIsSet : Bool = false;
    /** Indicates if further resizing is performed due to renderer resized */
    private var __adjustingSize : Bool = false;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        // padding = new Padding();

        autoSize = new AutoSize(true);
        autoSize.onChange = __autoSizeChanged;

        __createRenderer();

       __enableRendererResizeListener();
    }


    /**
     * Method to cleanup and release this object for garbage collector.
     */
    override public function dispose (disposeChildren:Bool = true) : Void
    {
        super.dispose(disposeChildren);

        __disableRendererResizeListener();
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
            __adjustingSize = true;
            width.px = __renderer.getWidth();
            __adjustingSize = false;
        }
        if (heightChanged && autoSize.height) {
            __adjustingSize = true;
            height.px = __renderer.getHeight();
            __adjustingSize = false;
        }

        if (__rendererOnResizeIsSet) {
            if (autoSize.neither()) __disableRendererResizeListener();
        } else {
            if (autoSize.either()) __enableRendererResizeListener();
        }
    }


    /**
     * Remove renderer.onResize listener
     */
    private inline function __disableRendererResizeListener () : Void
    {
        __renderer.onResize(null);
        __rendererOnResizeIsSet = false;
    }


    /**
     * Set renderer.onResize listener
     */
    private inline function __enableRendererResizeListener () : Void
    {
        __renderer.onResize(__rendererResized);
        __rendererOnResizeIsSet = true;
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
     * Called when `width` or `height` is changed.
     */
    override private function __propertyResized (changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (!__adjustingSize) {
            if (changed.isHorizontal()) {
                if (autoSize.width) autoSize.width = false;
            } else {
                if (autoSize.height) autoSize.height = false;
            }
        }

        super.__propertyResized(changed, previousUnits, previousValue);
    }


    /**
     * Getter for `renderer`.
     *
     * Override in descendants
     */
    private function get___renderer () : Renderer
    {
        return null;
    }

}//class RendererHolder