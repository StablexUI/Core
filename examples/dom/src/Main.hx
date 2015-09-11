package;

import js.Browser;
import sx.backend.dom.Backend;
import sx.Sx;
import sx.widgets.Widget;


/**
 * Entry point
 *
 */
class Main
{

    /**
     * Entry point
     *
     */
    static public inline function main () : Void
    {
        // haxe.Log.trace = function (v:Dynamic, ?infos:haxe.PosInfos) {
        //     var msg = infos.className + '.' + infos.methodName + '():' + infos.lineNumber + ': ';
        //     untyped __js__('console').log(msg);
        //     untyped __js__('console').log(v);
        // }

        Sx.setBackend(new Backend());

        var root = new Widget();
        root.width.px  = 100;
        root.height.px = 30;

        trace(root.display);

        Sx.attach(root);

        var fn;
        fn = function(time:Float) {
            Browser.window.requestAnimationFrame(fn);
            root.left.px ++;
            root.top.px ++;
        }
        fn(0);
    }


}//class Main