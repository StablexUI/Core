package sx.widgets;

import sx.backend.BitmapData;
import sx.backend.BitmapRenderer;
import sx.properties.metric.Size;
import sx.properties.metric.Units;
import sx.widgets.RendererHolder;
import sx.properties.Orientation;

using sx.tools.PropertiesTools;



/**
 * Bitmaps
 *
 */
class Bmp extends RendererHolder
{
    /** Bitmap data to render */
    public var bitmapData (default,set) : Null<BitmapData>;
    /** Bitmap renderer */
    public var renderer (default,null) : BitmapRenderer;
    /**
     * If `autoSize` is disabled, rendered bitmap will be stretched to `Bmp` widget size.
     * This option indicates if scaled bitmap should keep original aspect ratio.
     *
     * If both `autoSize.width` and `autoSize.height` are `true`, then `keepAspect` is ignored.
     * If `autoSize.width` is `false` and `autoSize.height` is `true` and `keepAspect` is `false` then bitmap width is stretched.
     * If `autoSize.width` is `true` and `autoSize.height` is `false` and `keepAspect` is `false` then bitmap height is stretched.
     * If both `autoSize.width` and `autoSize.height` are `false` and `keepAspect` is `false`, then bitmap width and height are stretched.
     * If both `autoSize.width` and `autoSize.height` are `false` and `keepAspect` is `true`, then one of bitmap width or height
     *      is stretched, while another one is scaled according to original bitmap aspect ratio.
     */
    public var keepAspect (default,set) : Bool = true;


    /**
     * Creates renderer instance
     */
    override private function __createRenderer () : Void
    {
        renderer = Sx.backendManager.bitmapRenderer(this);
    }


    /**
     * Called when `width` or `height` is changed.
     */
    override private function __propertyResized (changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        super.__propertyResized(changed, previousUnits, previousValue);
        if (!__adjustingSize) __updateBitmapScaling();
    }


    /**
     * Called when `padding` changed
     */
    override private function __paddingChanged (horizontal:Bool, vertical:Bool) : Void
    {
        __updateBitmapScaling();
        super.__paddingChanged(horizontal, vertical);
    }


    /**
     * Called when `autoSize` settings changed
     */
    override private function __autoSizeChanged (widthChanged:Bool, heightChanged:Bool) : Void
    {
        __updateBitmapScaling();
        super.__paddingChanged(widthChanged, heightChanged);
    }


    /**
     * Pass correct bitmap scaling to renderer
     */
    private inline function __updateBitmapScaling () : Void
    {
        if (autoSize.both()) {
            renderer.setScale(1, 1);
        } else if (autoSize.width) {
            __scaleBitmapHeight();
        } else if (autoSize.height) {
            __scaleBitmapWidth();
        } else {
            __scaleBitmapBoth();
        }
    }


    /**
     * Scale bitmap height while width left unscaled.
     */
    private inline function __scaleBitmapHeight () : Void
    {
        var bitmapHeight = renderer.getBitmapDataHeight();

        if (bitmapHeight <= 0) {
            renderer.setScale(0, 0);

        } else {
            if (keepAspect) {
                renderer.setScale(1, 1);

            } else {
                var renderHeight = height.px - padding.sum(Vertical);
                if (renderHeight <= 0) {
                    renderer.setScale(0, 0);
                } else {
                    var scaleY = renderHeight / bitmapHeight;
                    renderer.setScale(1, scaleY);
                }
            }
        }
    }


    /**
     * Scale bitmap width while height left unscaled.
     */
    private inline function __scaleBitmapWidth () : Void
    {
        var bitmapWidth = renderer.getBitmapDataWidth();

        if (bitmapWidth <= 0) {
            renderer.setScale(0, 0);

        } else {
            if (keepAspect) {
                renderer.setScale(1, 1);

            } else {
                var renderWidth = width.px - padding.sum(Horizontal);
                if (renderWidth <= 0) {
                    renderer.setScale(0, 0);
                } else {
                    var scaleX = renderWidth / bitmapWidth;
                    renderer.setScale(scaleX, 1);
                }
            }
        }
    }


    /**
     * Scale both width and height of bitmap
     */
    private inline function __scaleBitmapBoth () : Void
    {
        var bitmapWidth  = renderer.getBitmapDataWidth();
        var bitmapHeight = renderer.getBitmapDataHeight();

        if (bitmapWidth <= 0 || bitmapHeight <= 0) {
            renderer.setScale(0, 0);

        } else {
            var renderWidth  = width.px - padding.left.px - padding.right.px;
            var renderHeight = height.px - padding.top.px - padding.bottom.px;

            if (renderWidth <= 0 || renderHeight <= 0) {
                renderer.setScale(0, 0);

            } else {
                var scaleX = renderWidth / bitmapWidth;
                var scaleY = renderHeight / bitmapHeight;

                if (keepAspect) {
                    if (scaleX < scaleY) {
                        renderer.setScale(scaleX, scaleX);
                    } else {
                        renderer.setScale(scaleY, scaleY);
                    }
                } else {
                    renderer.setScale(scaleX, scaleY);
                }
            }
        }
    }


    /**
     * Setter `bitmapData`
     */
    private function set_bitmapData (value:BitmapData) : BitmapData
    {
        bitmapData = value;
        renderer.setBitmapData(bitmapData);

        return value;
    }


    /**
     * Setter `keepAspect`
     */
    private function set_keepAspect (value:Bool) : Bool
    {
        if (keepAspect != value) {
            keepAspect = value;
            __updateBitmapScaling();
        }

        return value;
    }


    /** Getters */
    override private function get___renderer () return renderer;

}//class Bmp