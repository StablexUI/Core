package sx.signals;

import haxe.Constraints.Function;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end



/**
 * Minimal required signal implementation for StablexUI
 *
 */
@:forward(copy)
abstract Signal<T:Function> (Array<T>)
{
    /** Amount of listeners attached to this signal */
    public var listenersCount (get,never) : Int;


    /**
     * Constructor
     */
    public inline function new () : Void
    {
        this = [];
    }


    /**
     * Attach signal handler
     */
    public inline function invoke (listener:T) : Void
    {
        this.push(listener);
    }


    /**
     * Attach `listener` only if it's not attached yet.
     */
    public inline function unique (listener:T) : Void
    {
        if (indexOf(listener) < 0) this.push(listener);
    }


    /**
     * Remove signal handler(s).
     *
     * If `listener` is `null` removes all handlers attached to this signal.
     */
    public function dontInvoke (listener:T = null) : Void
    {
        var index  = (listener == null ? 0 : indexOf(listener));
        var length = (listener == null ? this.length : 1);

        if (index >= 0) {
            this.splice(index, length);
        }
    }


    /**
     * Check if `listener` is attached to this signal.
     */
    public inline function willInvoke (listener:T) : Bool
    {
        return indexOf(listener) >= 0;
    }


    /**
     * Dispatch signal and invoke all attached handlers
     */
    macro public function dispatch (eThis:Expr, args:Array<Expr>) : Expr
    {
        var pos  = Context.currentPos();
        var loop = macro @:pos(pos) if ($eThis.listenersCount > 0) for (listener in $eThis.copy()) listener($a{args});

        return loop;
    }


    /**
     * Find index of `listener` in the list of handlers attached to this signal.
     */
    private function indexOf (listener:T) : Int
    {
        var index = -1;

        for (i in 0...this.length) {
            if (Reflect.compareMethods(this[i], listener)) {
                index = i;
                break;
            }
        }

        return index;
    }


    /** Getters */
    private inline function get_listenersCount () return this.length;

}//abstract Signal<T>