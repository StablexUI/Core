package sx.widgets;

import sx.backend.BitmapData;
import sx.backend.BitmapRenderer;
import sx.widgets.RendererHolder;



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


    // /**
    //  * Constructor
    //  */
    // public function new () : Void
    // {
    //     super();

    //     stretch = new Stretch();
    //     stretch.onChange.add(__stretchChanged);
    // }


    /**
     * Creates renderer instance
     */
    override private function __createRenderer () : Void
    {
        renderer = Sx.backendFactory.bitmapRenderer(this);
    }


    // /**
    //  * Called when stretching settings were changed
    //  */
    // private function __stretchChanged () : Void
    // {
    //     if (stretch.scale && autoSize.either()) {
    //         autoSize.set(false);
    //     }
    // }


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
        if (keepAspect == value) {
            keepAspect = value;
        } else {
            keepAspect = value;
            if (!autoSize.both()) renderer.refresh();
        }

        return value;
    }


    /** Getters */
    override private function get___renderer () return renderer;

}//class Bmp