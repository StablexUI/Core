package sx.backend.flash;

import flash.display.Sprite;
import sx.backend.flash.Stage;
import sx.backend.IDisplay;
import sx.widgets.Widget;


/**
 * Display implementation
 *
 */
@:access(sx.widgets.Widget)
class Display implements IDisplay
{
    /** flash sprite for display */
    public var sprite (default,null) : Sprite;
    /** Widget which is represented by this display */
    private var widget : Widget;
    /** Current display index */
    private var displayIndex : Int = -1;
    /** Stage which this display is currently rendered on */
    private var stage : Stage;

    /** Description */
    private var tmpColor : Int = 0;


    /**
     * Constructor
     */
    public function new (widget:Widget, sprite:Sprite = null) : Void
    {
        if (sprite == null) {
            sprite = new Sprite();

            var colors = [0xFF0000, 0x00FF00, 0x0000FF, 0x00FFFF];
            tmpColor = colors[Std.random(colors.length)];
        }

        this.widget = widget;
        this.sprite = sprite;
    }


    /**
     * Update visualization
     */
    public function update (currentStage:IStage, displayIndex:Int) : Void
    {
        if (stage != currentStage) {
            stage = cast currentStage;
            this.displayIndex = -1;
        }

        sprite.graphics.clear();
        sprite.graphics.beginFill(tmpColor);
        sprite.graphics.drawRect(0, 0, widget.width.px, widget.height.px);
        sprite.graphics.endFill();

        if (widget.__invalidMatrix) {
            var mx = sprite.transform.matrix;
            mx.a  = widget.__matrix.a;
            mx.b  = widget.__matrix.b;
            mx.c  = widget.__matrix.c;
            mx.d  = widget.__matrix.d;
            mx.tx = widget.__matrix.tx;
            mx.ty = widget.__matrix.ty;
            sprite.transform.matrix = mx;
        }

        if (this.displayIndex != displayIndex) {
            this.displayIndex = displayIndex;
            stage.container.addChildAt(sprite, displayIndex);
        }
    }


    /**
     * Method to remove all external references to this object and release it for garbage collector.
     */
    public function dispose () : Void
    {
        if (sprite.parent != null) {
            sprite.parent.removeChild(sprite);
        }

        stage = null;
        sprite = null;
    }



}//class Display