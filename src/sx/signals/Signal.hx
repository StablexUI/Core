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
@:forward(copy)
abstract Signal<T:Function> (Array<T>)
{

#if !macro

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
        if (__indexOf(listener) < 0) this.push(listener);
    }


    /**
     * Remove signal handler(s).
     *
     * If `listener` is `null` removes all handlers attached to this signal.
     */
    public function dontInvoke (listener:T = null) : Void
    {
        var index  = (listener == null ? 0 : __indexOf(listener));
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
        return __indexOf(listener) >= 0;
    }


    /**
     * Find index of `listener` in the list of handlers attached to this signal.
     */
    private function __indexOf (listener:T) : Int
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

#end

    /**
     * Dispatch signal and invoke all attached handlers
     *
     * Attached listeners should accept dispatching widget as the first argument.
     *
     * @param   dispatcher      Widget which dispatched this signal.
     */
    macro public function dispatch (eThis:Expr, dispatcher:ExprOf<Widget>, args:Array<Expr>) : Expr
    {
        args.unshift(dispatcher);
        var pos  = Context.currentPos();
        var loop = macro @:pos(pos) if ($eThis.listenersCount > 0) for (listener in $eThis.copy()) listener($a{args});

        return loop;
    }


    /**
     * Dispatch signal which will bubble through the display list.
     *
     * Attached listeners should accept widget which is currently processing signal as the first argument.
     * Attached listeners should accept widget which dispatched signal as the second argument.
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

        return macro @:pos(pos) {
            var sig__current__ = $dispatcher;
            var sig__class__   = Type.getClass($dispatcher);

            while (sig__current__ != null) {

                if (sig__current__.$signalProperty.listenersCount > 0) {
                    for (listener in sig__current__.$signalProperty.copy()) {
                        listener($a{args});
                    }
                }

                if (!Std.is(sig__current__.parent, sig__class__)) break;
                sig__current__ = cast sig__current__.parent;
            }
        }
    }


}//abstract Signal<T>