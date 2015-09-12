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
    /** Current display index */
    private var displayIndex : Int = -1;
    /** `sx.backend.IStage` which this display is currently rendered on */
    private var sxStage : Stage;

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
    public function update (renderData:RenderData) : Void
    {
        if (sxStage != renderData.stage) {
            sxStage = cast renderData.stage;
            displayIndex = -1;
        }

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

        if (displayIndex != renderData.displayIndex) {
            displayIndex = renderData.displayIndex;
            sxStage.container.addChildAt(this, displayIndex);
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

        sxStage = null;
    }



}//class Display