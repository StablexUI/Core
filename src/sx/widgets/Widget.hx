package sx.widgets;

import sx.backend.Backend;
import sx.backend.Point;
import sx.exceptions.LoopedResizeException;
import sx.exceptions.NotChildException;
import sx.exceptions.OutOfBoundsException;
import sx.layout.Layout;
import sx.properties.abstracts.ACoordinate;
import sx.properties.abstracts.ASize;
import sx.properties.Orientation;
import sx.properties.metric.Units;
import sx.properties.metric.Coordinate;
import sx.properties.displaylist.ArrayDisplayList;
import sx.properties.metric.Offset;
import sx.properties.metric.Size;
import sx.signals.ChildSignal;
import sx.signals.WidgetSignal;
import sx.signals.PointerSignal;
import sx.signals.SizeSignal;
import sx.skins.ASkin;
import sx.skins.Skin;
import sx.signals.Signal;
import sx.Sx;
import sx.themes.Theme;
import sx.tween.Tweener;

using sx.tools.WidgetTools;
using sx.tools.PropertiesTools;


/**
 * Base class for widgets
 *
 */
class Widget
{
    /**
     * Maximum allowed resizing depth.
     * When some event makes widget to be resized while `onResize` triggers the same event again.
     */
    static public inline var MAX_RESIZE_DEPTH = 5;

    /** Name for this widget */
    public var name : Null<String>;
    /** Parent widget */
    public var parent (get,never) : Null<Widget>;
    private var __parent (default,set) : Widget;
    /** Get amount of children */
    public var numChildren (default,null) : Int = 0;

    /** Position along X-axis measured from parent widget's left border */
    public var left (get,set) : ACoordinate;
    private var __left : Coordinate;
    /** Position along X-axis measured from parent widget's right border */
    public var right (get,set) : ACoordinate;
    private var __right : Coordinate;
    /** Position along Y-axis measured from parent widget's top border */
    public var top (get,set) : ACoordinate;
    private var __top : Coordinate;
    /** Position along Y-axis measured from parent widget's bottom border */
    public var bottom (get,set) : ACoordinate;
    private var __bottom : Coordinate;

    /**
     * Origin point used for scale & rotation (but should not affect position).
     * By default it's top left corner.
     */
    public var origin (get,never) : Offset;
    private var __origin : Offset;

    /**
     * Point used to additionally shift widget position.
     */
    public var offset (get,never) : Offset;
    private var __offset : Offset;

    /** Widget's width */
    public var width (get,set) : ASize;
    private var __width : Size;
    /** Widget's height */
    public var height (get,set) : ASize;
    private var __height : Size;

    /** Scale along X axis. Does not affect width. */
    public var scaleX (default,set) : Float = 1;
    /** Scale along Y axis. Does not affect height. */
    public var scaleY (default,set) : Float = 1;

    /** Clockwise rotation (degrees) */
    public var rotation (default,set) : Float = 0;

    /**
     * Transparency.
     * `0` - fully transparent.
     * `1` - fully opaque.
     */
    public var alpha (default,set) : Float = 1;
    /** Whether or not the display object is visible. */
    public var visible (default,set) : Bool = true;
    /** Controls whether widget children out of widget bounds should be rendered (`true`) or clipped (`false`) */
    public var overflow (default,set) : Bool = true;

    /**
     * Applied skin.
     *
     * Skin is refreshed only when assigning it to widget, resizing widget or when calling `widget.skin.refresh()`
     */
    public var skin (get,set) : Null<ASkin>;
    private var __skin : Skin;
    /**
     * Object which controls children positions inside this widget.
     *
     * Layouts arrange children only on assigning layout instance to widget, resizing widget and on adding/removing children.
     * To force arrange children assign layout again or call `widget.layout.arrangeChildren()`
     */
    public var layout (get,set) : Null<Layout>;
    private var __layout : Layout;

    /**
     * Indicates whether this widget is interactive.
     * Disabled widget also prevents interactivity of all children.
     */
    public var enabled (get,set) : Bool;
    private var __enabled : Bool = true;

    /**
     * Style name to apply.
     *
     * Style is applied immediately unless it's not a default style and widget is not initialized.
     * In that case style application will be delayed till widget initialization.
     * If you don't want to apply default style to your widget, assign `null` to this property.
     * If you need to apply default style before initialization and avoid style application on initialization, use following snippet:
     * ```
     *  widget.style = sx.themes.Theme.DEFAULT_STYLE;
     *  widget.style = null;
     * ```
     */
    public var style (default,set) : Null<String> = sx.themes.Theme.DEFAULT_STYLE;

    /** "Native" backend */
    public var backend (default,null) : Backend;

    /**
     * Indicates if widget was initialized.
     * To initialize widget add it to another initialized widget or call `widget.initialize()`.
     *
     * Until widget is initialized:
     *  - backend will not receive notifications about widget changes;
     *  - skin will not be rendered;
     *  - layout will not arrange children.
     */
    public var initialized (default,null) : Bool = false;

    /** Indicates if widget was disposed */
    public var disposed (default,null) : Bool = false;

    /** Tweening implementation */
    public var tween (get,never) : Tweener;
    private var __tween : Tweener;

    /** Signal dispatched when widget width or height is changed */
    public var onResize (get,never) : SizeSignal;
    private var __onResize : SizeSignal;
    /** Signal dispatched when widget position is changed */
    public var onMove (get,never) : SizeSignal;
    private var __onMove : SizeSignal;
    /** Signal dispatched after child was added via `addChild()` or `addChidlAt()` */
    public var onChildAdded (get,never) : ChildSignal;
    private var __onChildAdded : ChildSignal;
    /** Signal dispatched after child was removed via `removeChild()` or `removeChidlAt()` */
    public var onChildRemoved (get,never) : ChildSignal;
    private var __onChildRemoved : ChildSignal;
    /** Signal dispatched `parent` of a widget changed */
    public var onParentChanged (get,never) : ChildSignal;
    private var __onParentChanged : ChildSignal;
    /** Signal dispatched when `enabled` changed to `true` */
    public var onEnable (get,never) : WidgetSignal;
    private var __onEnable : WidgetSignal;
    /** Signal dispatched when `enabled` changed to `false` */
    public var onDisable (get,never) : WidgetSignal;
    private var __onDisable : WidgetSignal;
    /** Signal dispatched when widget is pressed (mouse down, touch down) */
    public var onPointerPress (get,never) : PointerSignal;
    private var __onPointerPress : PointerSignal;
    /** Signal dispatched when widget is released (mouse up, touch up) */
    public var onPointerRelease (get,never) : PointerSignal;
    private var __onPointerRelease : PointerSignal;
    /** Signal dispatched on click or tap */
    public var onPointerTap (get,never) : PointerSignal;
    private var __onPointerTap : PointerSignal;
    /** Alias for `onPointerTap` */
    public var onClick (get,never) : PointerSignal;
    /** Signal dispatched when pointer is moving over wiget */
    public var onPointerMove (get,never) : PointerSignal;
    private var __onPointerMove : PointerSignal;
    /** Signal dispatched when pointer moved inside a widget */
    public var onPointerOver (get,never) : PointerSignal;
    private var __onPointerOver : PointerSignal;
    /** Signal dispatched when pointer moved out of a widget */
    public var onPointerOut (get,never) : PointerSignal;
    private var __onPointerOut : PointerSignal;
    /** Signal dispatched after widget was initialized */
    public var onInitialize (get,never) : WidgetSignal;
    private var __onInitialize : WidgetSignal;
    /** Signal dispatched before disposing widget */
    public var onDispose (get,never) : WidgetSignal;
    private var __onDispose : WidgetSignal;

    /** Indicates if this widget attached listener to `parent.onResize` */
    private var __listeningParentResize : Bool = false;
    /**
     * Counter used to prevent endless resizes loop.
     * E.g. when child size depends on parent size while parent size also depends on children size.
     */
    private var __resizeCounter : Int = 0;


    /**
     * Cosntructor
     */
    public function new () : Void
    {
        __createBackend();

        __width = new Size(Horizontal);
        __width.pctSource = __parentWidthProvider;
        __width.onChange.add(__propertyResized);

        __height = new Size(Vertical);
        __height.pctSource = __parentHeightProvider;
        __height.onChange.add(__propertyResized);

        __left = new Coordinate(Horizontal);
        __left.pctSource = __parentWidthProvider;
        __left.onChange.add(__propertyMoved);

        __right = new Coordinate(Horizontal);
        __right.pctSource = __parentWidthProvider;
        __right.onChange.add(__propertyMoved);

        __top = new Coordinate(Vertical);
        __top.pctSource = __parentHeightProvider;
        __top.onChange.add(__propertyMoved);

        __bottom = new Coordinate(Vertical);
        __bottom.pctSource = __parentHeightProvider;
        __bottom.onChange.add(__propertyMoved);

        __left.pair      = get_right;
        __right.pair     = get_left;
        __top.pair       = get_bottom;
        __bottom.pair    = get_top;
        __left.ownerSize = __right.ownerSize = get_width;
        __top.ownerSize  = __bottom.ownerSize = get_height;

        __left.select();
        __top.select();
    }


    /**
     * Initialize widget.
     */
    public function initialize () : Void
    {
        if (initialized) return;

        if (style == Theme.DEFAULT_STYLE) {
            __applyStyle();
        }

        initialized = true;

        __initializeSelf();
        __onInitialize.dispatch(this);
        __initializeChildren();
    }


    /**
     * Add `child` to display list of this widget.
     *
     * Returns added child.
     */
    public function addChild (child:Widget) : Widget
    {
        if (child.parent != null) child.parent.removeChild(child);

        backend.addWidget(child);
        numChildren++;
        child.__parent = this;

        __onChildAdded.dispatch(this, child, numChildren - 1);
        child.__onParentChanged.dispatch(this, child, numChildren - 1);

        return child;
    }


    /**
     * Insert `child` at specified `index` of display list of this widget..
     *
     * If `index` is negative, calculate required index from the end of display list (`numChildren` + index).
     * If `index` is out of bounds, `child` will be added to the end (positive `index`) or to the beginning
     * (negative `index`) of display list.
     *
     * Returns added `child`.
     */
    public function addChildAt (child:Widget, index:Int) : Widget
    {
        if (child.parent != null) child.parent.removeChild(child);

        backend.addWidgetAt(child, index);
        numChildren++;
        child.__parent = this;

        if (__onChildAdded != null || child.__onParentChanged != null) {
            index = getChildIndex(child);
            __onChildAdded.dispatch(this, child, index);
            child.__onParentChanged.dispatch(this, child, index);
        }

        return child;
    }


    /**
     * Remove `child` from display list of this widget.
     *
     * Returns removed child.
     * Returns `null` if this widget is not a parent for this `child`.
     */
    public function removeChild (child:Widget) : Null<Widget>
    {
        if (child.parent == this) {
            var index = 0;
            if (__onChildRemoved != null || child.__onParentChanged != null) {
                index = getChildIndex(child);
            }

            backend.removeWidget(child);
            numChildren--;
            child.__parent = null;

            __onChildRemoved.dispatch(this, child, index);
            child.__onParentChanged.dispatch(null, child, 0);

            return child;
        } else {
            return null;
        }
    }


    /**
     * Remove child at `index` of display list of this widget.
     *
     * If `index` is negative, calculate required index from the end of display list (`numChildren` + index).
     *
     * Returns removed child or `null` if `index` is out of bounds.
     */
    public function removeChildAt (index:Int) : Null<Widget>
    {
        var removed = backend.removeWidgetAt(index);
        if (removed != null) {
            numChildren--;
            removed.__parent = null;

            if (__onChildRemoved != null || removed.__onParentChanged != null) {
                if (index < 0) index = numChildren + 1 + index;

                __onChildRemoved.dispatch(this, removed, index);
                removed.__onParentChanged.dispatch(null, removed, 0);
            }
        }

        return removed;
    }


    /**
     * Remove all children from child with `beginIndex` position to child with `endIndex` (including).
     *
     * If index is negative, find required child from the end of display list.
     *
     * Returns amount of children removed.
     */
    public function removeChildren (beginIndex:Int = 0, endIndex:Int = -1) : Int
    {
        if (beginIndex < 0) beginIndex = numChildren + beginIndex;
        if (beginIndex < 0) beginIndex = 0;
        if (endIndex < 0) {
            endIndex = numChildren + endIndex;
        } else if (endIndex >= numChildren) {
            endIndex = numChildren - 1;
        }

        if (beginIndex >= numChildren || endIndex < beginIndex) return 0;

        var removed = endIndex - beginIndex + 1;
        while (beginIndex <= endIndex) {
            removeChildAt(beginIndex);
            endIndex--;
        }

        return removed;
    }


    /**
     * Determines if `child` is this widget itself or if `child` is in display list of this widget at any depth.
     */
    public function contains (child:Widget) : Bool
    {
        while (child != null) {
            if (child == this) return true;
            child = child.parent;
        }

        return false;
    }


    /**
     * Get index of a `child` in a list of children of this widget.
     *
     * @throws sx.exceptions.NotChildException If `child` is not direct child of this widget.
     */
    public function getChildIndex (child:Widget) : Int
    {
        if (child.parent != this) throw new NotChildException();

        return backend.getWidgetIndex(child);
    }


    /**
     * Move `child` to specified `index` in display list.
     *
     * If `index` is greater then amount of children, `child` will be added to the end of display list.
     * If `index` is negative, required position will be calculated from the end of display list.
     * If `index` is negative and calculated position is less than zero, `child` will be added at the beginning of display list.
     *
     * Returns new position of a `child` in display list.
     *
     * @throws sx.exceptions.NotChildException If `child` is not direct child of this widget.
     */
    public function setChildIndex (child:Widget, index:Int) : Int
    {
        if (child.parent != this) throw new NotChildException();

        return backend.setWidgetIndex(child, index);
    }


    /**
     * Get child at specified `index`.
     *
     * If `index` is negative, required child is calculated from the end of display list.
     *
     * Returns child located at `index`, or returns `null` if `index` is out of bounds.
     */
    public function getChildAt (index:Int) : Null<Widget>
    {
        return backend.getWidgetAt(index);
    }


    /**
     * Swap two specified child widgets in display list.
     *
     * @throws sx.exceptions.NotChildException() If eighter `child1` or `child2` are not a child of this widget.
     */
    public function swapChildren (child1:Widget, child2:Widget) : Void
    {
        if (child1.parent != this || child2.parent != this) throw new NotChildException();
        backend.swapWidgets(child1, child2);
    }


    /**
     * Swap children at specified indexes.
     *
     * If indices are negative, required children are calculated from the end of display list.
     *
     * @throws sx.exceptions.OutOfBoundsException
     */
    public function swapChildrenAt (index1:Int, index2:Int) : Void
    {
        if (index1 < 0) index1 += numChildren;
        if (index2 < 0) index2 += numChildren;

        if (index1 < 0 || index1 >= numChildren || index2 < 0 || index2 > numChildren) {
            throw new OutOfBoundsException('Provided index does not exist in display list of this widget.');
        }

        backend.swapWidgetsAt(index1, index2);
    }


    /**
     * Find child widget by `name` (recursively) and return it
     */
    public function getChild (name:String) : Null<Widget>
    {
        var child : Widget = null;
        for (i in 0...numChildren) {
            child = getChildAt(i);
            if (child.name == name) {
                return child;
            }

            child = child.getChild(name);
            if (child != null) {
                return child;
            }
        }

        return null;
    }


    /**
     * Find child of `cls` type by `name` (recursively) and return it as instance of specified class.
     */
    public function getChildAs<T:Widget> (name:String, cls:Class<T>) : Null<T>
    {
        var child : Widget = null;
        for (i in 0...numChildren) {
            child = getChildAt(i);
            if (child.name == name && Std.is(child, cls)) {
                return cast child;
            }

            child = child.getChildAs(name, cls);
            if (child != null) {
                return cast child;
            }
        }

        return null;
    }


    /**
     * Find parent widget by `name` (recursively up on display list)
     */
    public function getParent (name:String) : Widget
    {
        var parent = this.parent;
        while (parent != null && parent.name != name) {
            parent = parent.parent;
        }

        return parent;
    }


    /**
     * Find parent widget of `cls` type by `name` (recursively up on display list)
     */
    public function getParentAs<T:Widget> (name:String, cls:T) : T
    {
        var parent = this.parent;
        while (parent != null && (parent.name != name || !Std.is(parent, cls))) {
            parent = parent.parent;
        }

        return (parent == null ? null : cast parent);
    }


    /**
     * Check if this widget and all his parents are enabled
     */
    public function isEnabled () : Bool
    {
        var current = this;
        do {
            if (!current.enabled) return false;
            current = current.parent;
        } while (current != null);

        return true;
    }


    /**
     * Convert point with global coordinates to point with local coordinates.
     */
    public function globalToLocal (point:Point) : Point
    {
        return backend.widgetGlobalToLocal(point);
    }


    /**
     * Convert point with local coordinates to point with global coordinates.
     */
    public function localToGlobal (point:Point) : Point
    {
        return backend.widgetLocalToGlobal(point);
    }


    /**
     * Method to cleanup and release this object for garbage collector.
     */
    public function dispose (disposeChildren:Bool = true) : Void
    {
        __onDispose.dispatch(this);
        disposed = true;

        if (parent != null) {
            parent.removeChild(this);
        }

        if (skin != null) skin = null;
        if (layout != null) layout = null;

        if (disposeChildren) {
            while (numChildren > 0) getChildAt(0).dispose(true);
        } else {
            removeChildren();
        }

        if (__tween != null) __tween.stop();

        backend.widgetDisposed();
    }


    /**
     * Set backend instance
     */
    private function __createBackend () : Void
    {
        backend = Sx.backendManager.widgetBackend(this);
    }


    /**
     * Called when `width` or `height` is changed.
     */
    private function __propertyResized (changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        __affectParentResizeListener(changed, previousUnits);
        __resized(changed, previousUnits, previousValue);
    }


    /**
     * Called when widget resized
     */
    private inline function __resized (changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        __resizeCounter++;
        if (__resizeCounter > MAX_RESIZE_DEPTH) throw new LoopedResizeException();

        if (initialized) backend.widgetResized();

        __onResize.dispatch(this, changed, previousUnits, previousValue);

        //notify backend about widget movement if widget position is defined by `right` or `bottom`
        if (changed.isHorizontal() && right.selected) __moved();
        if (changed.isVertical() && bottom.selected) __moved();

        __resizeCounter--;
    }


    /**
     * Called when `left`, `right`, `bottom` or `top` are changed.
     */
    private function __propertyMoved (changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        __affectParentResizeListener(changed, previousUnits);
        __moved();
        __onMove.dispatch(this, changed, previousUnits, previousValue);
    }


    /**
     * Called when widget position changed
     */
    private inline function __moved () : Void
    {
        if (initialized) backend.widgetMoved();
    }


    /**
     * Called when `origin` is changed.
     */
    private function __originChanged () : Void
    {
        if (initialized) backend.widgetOriginChanged();
    }


    /**
     * Called when `offset` is changed.
     */
    private function __offsetChanged () : Void
    {
        if (initialized) backend.widgetOffsetChanged();
    }


    /**
     * Provides values for percentage calculations of width, left and right properties
     */
    private function __parentWidthProvider () : Size
    {
        return (parent == null ? Size.zeroProperty : parent.width);
    }


    /**
     * Provides values for percentage calculations of height, top and bottom properties
     */
    private function __parentHeightProvider () : Size
    {
        return (parent == null ? Size.zeroProperty : parent.height);
    }


    /**
     * Listener for parent size changes
     */
    private function __parentResized (parent:Widget, changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        //parent width changed
        if (changed.isHorizontal()) {
            __reactParentResize(left, width);

        //parent height changed
        } else {
            __reactParentResize(top, height);
        }
    }


    /**
     * React on parent resize depending on position and size settings of one dimension.
     *
     * @param   position    `left` or `top`
     * @param   size        `width` or `height`
     */
    private inline function __reactParentResize (position:Coordinate, size:Size) : Void
    {
        //check size
        if (size.units == Percent) {
            __resized(size, Percent, size.pct);
        }

        //widget moves if `left` or `top` changed while set to `Percent`
        if (position.selected) {
            if (position.units == Percent) __moved();
        //or when `right` or `bottom` changed with any units
        } else {
            __moved();
        }
    }


    /**
     * Add/remove parent onResize listener when this widget moved/resized.
     */
    private inline function __affectParentResizeListener (changed:Size, previousUnits:Units) : Void
    {
        if (parent != null) {
            if (__listeningParentResize) {
                //right & bottom always depend on parent size
                if (changed != __right && changed != __top) {
                    //moved away from percentage
                    if (previousUnits == Percent && previousUnits != changed.units) {
                        __updateParentResizeListener();
                    }
                }
            } else {
                if (changed.units == Percent || changed == __right || changed == __bottom) {
                    __listeningParentResize = true;
                    parent.onResize.add(__parentResized);
                }
            }
        }
    }


    /**
     * Add/remove listener to parent.onResize.
     */
    private function __updateParentResizeListener () : Void
    {
        var size     = this.sizeDependsOnParent();
        var position = this.positionDependsOnParent();

        if (size || position) {
            __listeningParentResize = true;
            parent.onResize.add(__parentResized);
        } else if (!size && !position) {
            __listeningParentResize = false;
            parent.onResize.remove(__parentResized);
        }
    }


    /**
     * Apply current style to this widget
     */
    private inline function __applyStyle () : Void
    {
        if (style != null && Sx.theme != null) {
            Sx.theme.apply(this);
        }
    }


    /**
     * Initialize this widget (without children)
     */
    private function __initializeSelf () : Void
    {
        if (__offset != null) backend.widgetOffsetChanged();
        if (__origin != null) backend.widgetOriginChanged();
        if (__width.notZero() || !__height.notZero()) {
            backend.widgetResized();
        }
        if (__left.notZero() || __right.selected || __top.notZero() || __bottom.selected) {
            backend.widgetMoved();
        }
        if (rotation != 0) backend.widgetRotated();
        if (scaleX != 1) backend.widgetScaledX();
        if (scaleY != 1) backend.widgetScaledY();
        if (alpha != 1) backend.widgetAlphaChanged();
        if (!visible) backend.widgetVisibilityChanged();
        if (!overflow) backend.widgetOverflowChanged();
        if (__skin != null) {
            skin.refresh();
            backend.widgetSkinChanged();
        }
    }


    /**
     * Initialize children
     */
    private function __initializeChildren () : Void
    {
        //initialize children
        for (i in 0...numChildren) {
            getChildAt(i).initialize();
        }
    }


    /**
     * Setter for `rotation`
     */
    private function set_rotation (rotation:Float) : Float
    {
        this.rotation = rotation;
        if (initialized) backend.widgetRotated();

        return rotation;
    }


    /**
     * Setter for `scaleX`
     */
    private function set_scaleX (scaleX:Float) : Float
    {
        this.scaleX = scaleX;
        if (initialized) backend.widgetScaledX();

        return scaleX;
    }


    /**
     * Setter for `scaleY`
     */
    private function set_scaleY (scaleY:Float) : Float
    {
        this.scaleY = scaleY;
        if (initialized) backend.widgetScaledY();

        return scaleY;
    }


    /**
     * Setter for `alpha`
     */
    private function set_alpha (alpha:Float) : Float
    {
        this.alpha = alpha;
        if (initialized) backend.widgetAlphaChanged();

        return alpha;
    }


    /**
     * Setter `visible`
     */
    private function set_visible (visible:Bool) : Bool
    {
        this.visible = visible;
        if (initialized) backend.widgetVisibilityChanged();

        return visible;
    }


    /**
     * Setter `skin`
     */
    private function set_skin (value:ASkin) : ASkin
    {
        if (__skin == value) return value;

        if (__skin != null) {
            __skin.removed();
            if (initialized) backend.widgetSkinChanged();
        }

        __skin = value;
        if (__skin != null) {
            __skin.usedBy(this);
            if (initialized) backend.widgetSkinChanged();
        }

        return value;
    }


    /**
     * Setter `layout`
     */
    private function set_layout (value:Layout) : Layout
    {
        if (__layout != null) __layout.removed();
        __layout = value;
        if (__layout != null) __layout.usedBy(this);

        return value;
    }


    /**
     * Setter `style`
     */
    private function set_style (value:String) : String
    {
        style = value;
        __applyStyle();

        return value;
    }


    /**
     * Getter for `origin`
     */
    private function get_origin () : Offset
    {
        if (__origin == null) {
            __origin = new Offset(get_width, get_height);
            __origin.onChange.add(__originChanged);
        }

        return __origin;
    }


    /**
     * Getter for `offset`
     */
    private function get_offset () : Offset
    {
        if (__offset == null) {
            __offset = new Offset(get_width, get_height);
            __offset.onChange.add(__offsetChanged);
        }

        return __offset;
    }


    /**
     * Setter `__parent`
     */
    private inline function set___parent (value:Widget) : Widget
    {
        if (__listeningParentResize && parent != null) {
            __listeningParentResize = false;
            parent.onResize.remove(__parentResized);
        }

        __parent = value;
        if (__parent != null) {
            __updateParentResizeListener();
            if (__parent.initialized && !initialized) {
                initialize();
            }
        }

        return value;
    }


    /**
     * Setter `enabled`
     */
    private function set_enabled (value:Bool) : Bool
    {
        if (__enabled == value) return value;

        __enabled = value;

        if (value) {
            __onEnable.dispatch(this);
        } else {
            __onDisable.dispatch(this);
        }

        return value;
    }


    /**
     * Getter `tween`
     */
    private function get_tween () : Tweener
    {
        if (__tween == null) {
            __tween = new Tweener();
        }

        return __tween;
    }


    /**
     * Setter for `overflow`
     */
    private function set_overflow (value:Bool) : Bool
    {
        if (overflow != value) {
            overflow = value;
            if (initialized) backend.widgetOverflowChanged();
        }

        return value;
    }


    /** Getters */
    private function get_parent ()          return __parent;
    private function get_width ()           return __width;
    private function get_height ()          return __height;
    private function get_left ()            return __left;
    private function get_right ()           return __right;
    private function get_top ()             return __top;
    private function get_bottom ()          return __bottom;
    private function get_skin ()            return __skin;
    private function get_layout ()          return __layout;
    private function get_enabled ()         return __enabled;

    /** Setters */
    private function set_left (v)       {__left.copyValueFrom(v); return __left;}
    private function set_right (v)      {__right.copyValueFrom(v); return __right;}
    private function set_top (v)        {__top.copyValueFrom(v); return __top;}
    private function set_bottom (v)     {__bottom.copyValueFrom(v); return __bottom;}
    private function set_width (v)      return __width.copyValueFrom(v);
    private function set_height (v)     return __height.copyValueFrom(v);

    /** Typical signal getters */
    private function get_onResize ()            return (__onResize == null ? __onResize = new Signal() : __onResize);
    private function get_onMove ()              return (__onMove == null ? __onMove = new Signal() : __onMove);
    private function get_onInitialize ()        return (__onInitialize == null ? __onInitialize = new Signal() : __onInitialize);
    private function get_onDispose ()           return (__onDispose == null ? __onDispose = new Signal() : __onDispose);
    private function get_onChildAdded ()        return (__onChildAdded == null ? __onChildAdded = new Signal() : __onChildAdded);
    private function get_onChildRemoved ()      return (__onChildRemoved == null ? __onChildRemoved = new Signal() : __onChildRemoved);
    private function get_onEnable ()            return (__onEnable == null ? __onEnable = new Signal() : __onEnable);
    private function get_onDisable ()           return (__onDisable == null ? __onDisable = new Signal() : __onDisable);
    private function get_onParentChanged ()     return (__onParentChanged == null ? __onParentChanged = new Signal() : __onParentChanged);
    private function get_onPointerPress ()      return (__onPointerPress == null ? __onPointerPress = new Signal() : __onPointerPress);
    private function get_onPointerRelease ()    return (__onPointerRelease == null ? __onPointerRelease = new Signal() : __onPointerRelease);
    private function get_onPointerTap ()        return (__onPointerTap == null ? __onPointerTap = new Signal() : __onPointerTap);
    private function get_onClick ()             return (__onPointerTap == null ? __onPointerTap = new Signal() : __onPointerTap);
    private function get_onPointerMove ()       return (__onPointerMove == null ? __onPointerMove = new Signal() : __onPointerMove);
    private function get_onPointerOver ()       return (__onPointerOver == null ? __onPointerOver = new Signal() : __onPointerOver);
    private function get_onPointerOut ()        return (__onPointerOut == null ? __onPointerOut = new Signal() : __onPointerOut);


}//class Widget