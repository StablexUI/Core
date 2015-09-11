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
        root.left.px = 200;
        root.top.px  = 200;
        root.width.px  = 100;
        root.height.px = 30;

        var child = root.addChild(new Widget());
        child.left.px = 50;
        child.bottom.px = -15;
        child.width.pct = 100;
        child.height.pct = 100;

        root.display == child.display;

        Sx.attach(root);

        // root.rotation = 45;
        root.scaleX = 1.5;
        // root.scaleY = Math.cos(a);


        var fn;
        var a = 0.;
        fn = function(time:Float) {
            Browser.window.requestAnimationFrame(fn);

            // root.left.px += 0.1;
            // root.top.px += 0.1;

            root.rotation += 0.1;
            // root.scaleX = 1 + Math.sin(a);
            // root.scaleY = 1 + Math.cos(a);

            a += 0.02;
        }
        fn(0);
    }


}//class Main