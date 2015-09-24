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
    /** For internal usage */
    private var __helperSize : Size;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        padding = new Padding();
        padding.ownerWidth  = __widthProviderForPadding;
        padding.ownerHeight = __heightProviderForPadding;
        padding.onChange    = __paddingChanged;

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
            __adjustSize(width, __renderer.getWidth(), padding.left, padding.right);
        }
        if (heightChanged && autoSize.height) {
            __adjustSize(height, __renderer.getHeight(), padding.top, padding.bottom);
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
        if (autoSize.width) __adjustSize(width, widthPx, padding.left, padding.right);
        if (autoSize.height) __adjustSize(height, heightPx, padding.top, padding.bottom);
    }


    /**
     * Called when `width` or `height` is changed.
     */
    override private function __propertyResized (changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (!__adjustingSize) {
            if (changed.isHorizontal()) {
                if (autoSize.width) autoSize.width = false;
                __renderer.setAvailableAreaWidth(changed.px - padding.left.px - padding.right.px);
            } else {
                if (autoSize.height) autoSize.height = false;
                __renderer.setAvailableAreaHeight(changed.px - padding.top.px - padding.bottom.px);
            }
        }

        super.__propertyResized(changed, previousUnits, previousValue);
    }


    /**
     * Set `size` value according to renderer size.
     */
    private inline function __adjustSize (size:Size, rendererSizePx:Float, paddingSide1:Size, paddingSide2:Size) : Void
    {
        __adjustingSize = true;
        size.px = rendererSizePx + paddingSide1.px + paddingSide2.px;
        __adjustingSize = false;
    }


    /**
     * Called when `padding` changed
     */
    private function __paddingChanged (horizontal:Bool, vertical:Bool) : Void
    {
        if (horizontal) {
            if (autoSize.width) {
                __adjustSize(width, __renderer.getWidth(), padding.left, padding.right);
            } else {
                __renderer.setAvailableAreaWidth(width.px - padding.left.px - padding.right.px);
            }
        }
        if (vertical) {
            if (autoSize.height) {
                __adjustSize(height, __renderer.getHeight(), padding.top, padding.bottom);
            } else {
                __renderer.setAvailableAreaHeight(height.px - padding.top.px - padding.bottom.px);
            }
        }
    }


    /**
     * Provides `width` for padding calculations
     */
    private function __widthProviderForPadding () : Size
    {
        if (autoSize.width) {
            var helperSize = __getPaddedRendererSize(padding.left, padding.right, __renderer.getWidth());

            return helperSize;

        } else {
            return width;
        }
    }


    /**
     * Provides `width` for padding calculations
     */
    private function __heightProviderForPadding () : Size
    {
        if (autoSize.width) {
            var helperSize = __getPaddedRendererSize(padding.top, padding.bottom, __renderer.getHeight());

            return helperSize;

        } else {
            return width;
        }
    }


    /**
     * Returns `__helperSize` width value set to renderer size + padding size
     */
    private inline function __getPaddedRendererSize (paddingSide1:Size, paddingSide2:Size, rendererSizePx:Float) : Size
    {
        var paddingSide1Px = __getPaddingPixels(paddingSide1, paddingSide2);
        var paddingSide2Px = __getPaddingPixels(paddingSide2, paddingSide1);

        var helperSize = __getHelperSize();
        helperSize.px = rendererSizePx + paddingSide1Px + paddingSide2Px;

        return __helperSize;
    }


    /**
     * Calculate padding in pixels for specified `paddingSide`
     */
    private inline function __getPaddingPixels (paddingSide:Size, oppositeSide:Size) : Float
    {
        switch (paddingSide.units) {
            case Percent :
                var rendererSize = (paddingSide.isHorizontal() ? __renderer.getWidth() : __renderer.getHeight());
                var holderSize   = switch (oppositeSide.units) {
                    case Percent : rendererSize / (0.01 * (100 - paddingSide.pct - oppositeSide.pct));
                    case _       : (rendererSize + oppositeSide.px) / (0.01 * (100 - paddingSide.pct));
                }

                return paddingSide.pct * 0.01 * holderSize;

            case _     :
                return paddingSide.px;
        }
    }


    /**
     * Get `Size` instance for various temporary needs
     */
    private inline function __getHelperSize () : Size
    {
        if (__helperSize == null) __helperSize = new Size();

        return __helperSize;
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