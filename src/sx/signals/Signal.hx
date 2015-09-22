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
    public function invoke (listener:T) : Void
    {
        __cloneListenersInUse();
        __listeners.push(listener);
    }


    /**
     * Attach `listener` only if it's not attached yet.
     */
    public function unique (listener:T) : Void
    {
        if (__indexOf(listener) < 0) {
            __cloneListenersInUse();
            __listeners.push(listener);
        }
    }


    /**
     * Remove signal handler(s).
     *
     * If `listener` is `null` then this method removes all handlers attached to this signal.
     */
    public function dontInvoke (listener:T = null) : Void
    {
        var index  = (listener == null ? 0 : __indexOf(listener));
        var length = (listener == null ? __listeners.length : 1);

        if (index >= 0) {
            __cloneListenersInUse();
            __listeners.splice(index, length);
        }
    }


    /**
     * Check if `listener` is attached to this signal.
     */
    public function willInvoke (listener:T) : Bool
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
        var loop = macro @:privateAccess if ($eThis.__listeners.length > 0) {
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
     * Dispatch signal which will bubble through the display list. Works only for signals of widgets.
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
            var sig__class__   = Type.getClass($dispatcher);

            while (sig__current__ != null) {

                if (sig__current__.$signalProperty.__listeners.length > 0) {

                    if (sig__current__.$signalProperty.__listenersInUse) {
                        for (listener in sig__current__.$signalProperty.__listeners) listener($a{args});

                    } else {
                        sig__current__.$signalProperty.__listenersInUse = true;
                        for (listener in sig__current__.$signalProperty.__listeners) listener($a{args});
                        sig__current__.$signalProperty.__listenersInUse = false;
                    }
                }

                if (!Std.is(sig__current__.parent, sig__class__)) break;
                sig__current__ = cast sig__current__.parent;
            }
        }
    }


}//abstract Signal<T>