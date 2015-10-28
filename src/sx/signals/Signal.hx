package sx.signals;

import haxe.Constraints.Function;

#if !macro
import sx.widgets.Widget;
#else
import haxe.macro.Context;
import haxe.macro.Expr;
#end



/**
 * Minimal required signal implementation for StablexUI
 *
 */
class Signal<T:Function>
{

#if !macro

    /** Amount of listeners attached to this signal */
    public var listenersCount (get,never) : Int;

    /** Attached listeners */
    private var __listeners : Array<T>;
    /** Indicates if `__listeners` are currently iterated over */
    private var __listenersInUse : Bool = false;


    /**
     * Constructor
     */
    public function new () : Void
    {
        __listeners = [];
    }


    /**
     * Attach signal handler
     */
    public function add (listener:T) : Void
    {
        __cloneListenersInUse();
        __listeners.push(listener);
    }


    /**
     * Attach `listener` only if it's not attached yet.
     *
     * Returns `true` if `listener` successfully attached.
     * Returns `false` if `listener` was already attached previously.
     */
    public function unique (listener:T) : Bool
    {
        if (__indexOf(listener) >= 0) return false;

        __cloneListenersInUse();
        __listeners.push(listener);

        return true;
    }


    /**
     * Remove signal handler.
     *
     * Returns `true` if `listener` successfully removed.
     * Returns `false` if `listener` was not attached to this signal.
     */
    public function remove (listener:T) : Bool
    {
        var index  = __indexOf(listener);
        if (index < 0) return false;

        __cloneListenersInUse();
        __listeners.splice(index, 1);

        return true;
    }


    // /**
    //  * Remove all attached listeners.
    //  */
    // public function clear () : Void
    // {
    //     __listeners = [];
    // }


    /**
     * Check if `listener` is attached to this signal.
     */
    public function will (listener:T) : Bool
    {
        return __indexOf(listener) >= 0;
    }


    /**
     * Find index of `listener` in the list of handlers attached to this signal.
     */
    private function __indexOf (listener:T) : Int
    {
        var index = -1;

        for (i in 0...__listeners.length) {
            if (Reflect.compareMethods(__listeners[i], listener)) {
                index = i;
                break;
            }
        }

        return index;
    }


    /**
     * Make a copy of listeners list if it's iterated now
     */
    private inline function __cloneListenersInUse () : Void
    {
        if (__listenersInUse) {
            __listeners = __listeners.copy();
            __listenersInUse = false;
        }
    }


    /** Getters */
    private function get_listenersCount () return __listeners.length;

#end

    /**
     * Dispatch signal and invoke all attached handlers
     *
     */
    macro public function dispatch (eThis:Expr, args:Array<Expr>) : Expr
    {
        var pos  = Context.currentPos();
        var loop = macro @:privateAccess if ($eThis != null && $eThis.__listeners.length > 0) {
            if ($eThis.__listenersInUse) {
                for (listener in $eThis.__listeners) listener($a{args});
                #if macro false; #end //fun bug in Haxe 3.2
            } else {
                $eThis.__listenersInUse = true;
                for (listener in $eThis.__listeners) listener($a{args});
                $eThis.__listenersInUse = false;
            }
        }

        return loop;
    }


    /**
     * Dispatch signal which will bubble through the display list. Works only for signals of `sx.widgets.Widget` class.
     *
     * @param   signalProperty      Widget property name for signals of this type.
     * @param   dispatcher          Widget which dispatched this signal.
     */
    macro public function bubbleDispatch (eThis:Expr, signalProperty:Expr, dispatcher:ExprOf<Widget>, args:Array<Expr>) : Expr
    {
        var pos = Context.currentPos();

        var signalProperty : String = switch (signalProperty.expr) {
            case EConst(CIdent(ident)) : ident;
            case _                     : Context.error('`signalProperty` argument accepts identifiers of signal properties only', pos);
        }

        args.unshift(dispatcher);
        args.unshift(macro sig__current__);

        return macro @:privateAccess {
            var sig__current__ = $dispatcher;

            while (sig__current__ != null) {

                if (sig__current__.$signalProperty != null && sig__current__.$signalProperty.__listeners.length > 0) {

                    if (sig__current__.$signalProperty.__listenersInUse) {
                        for (listener in sig__current__.$signalProperty.__listeners) listener($a{args});

                    } else {
                        sig__current__.$signalProperty.__listenersInUse = true;
                        for (listener in sig__current__.$signalProperty.__listeners) listener($a{args});
                        sig__current__.$signalProperty.__listenersInUse = false;
                    }
                }

                sig__current__ = cast sig__current__.parent;
            }
        }
    }


}//abstract Signal<T>