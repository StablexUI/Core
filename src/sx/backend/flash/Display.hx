package sx.backend.flash;

import flash.display.Sprite;
import sx.backend.flash.Stage;
import sx.backend.IDisplay;
import sx.Sx;
import sx.widgets.Widget;
import sx.properties.Validation;


/**
 * Display implementation
 *
 */
@:access(sx.widgets.Widget)
class Display extends Sprite implements IDisplay
{
    /** Widget which is represented by this display */
    private var widget : Widget;

    /** Description */
    private var tmpColor : Int = 0;


    /**
     * Constructor
     */
    public function new (widget:Widget) : Void
    {
        super();

        tmpColor = Std.random(0xFFFFFF);

        this.widget = widget;
    }


    /**
     * Update visualization
     */
    public function update (renderData:RenderData, globalAlpha:Float) : Void
    {
        if (widget.validation.isInvalid(SIZE)) {
            graphics.clear();
            graphics.beginFill(tmpColor);
            graphics.drawRect(0, 0, widget.width.px, widget.height.px);
            graphics.endFill();
        }

        if (widget.validation.isInvalid(MATRIX)) {
            var mx = transform.matrix;
            mx.a  = widget.__matrix.a;
            mx.b  = widget.__matrix.b;
            mx.c  = widget.__matrix.c;
            mx.d  = widget.__matrix.d;
            mx.tx = widget.__matrix.tx;
            mx.ty = widget.__matrix.ty;
            transform.matrix = mx;
        }

        if (widget.validation.isInvalid(DISPLAY_INDEX)) {
            var stage : Stage = cast renderData.stage;
            stage.container.addChildAt(this, renderData.displayIndex);
        }

        if (widget.validation.isInvalid(ALPHA)) {
            alpha = globalAlpha;
        }
    }


    /**
     * Method to remove all external references to this object and release it for garbage collector.
     */
    public function dispose () : Void
    {
        if (parent != null) {
            parent.removeChild(this);
        }
    }



}//class Display