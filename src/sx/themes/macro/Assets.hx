package sx.themes.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;

using StringTools;
using sys.FileSystem;
#end


/**
 * Assets macros
 *
 */
class Assets
{

#if macro
    /** Cache of class names of embedded resources */
    static private var __embedded : Map<String,String> = new Map();
    /** Description */
    static private var __erNonIdentChars = ~/[^a-zA-Z_0-9]/g;
#end

    /**
     * Embeds font and returns an instance of `flash.text.Font`
     */
    macro static public function font (fontPath:String) : Expr
    {
        var className = __embedFont(fontPath);

        return Context.parse('new $className()', Context.currentPos());
    }


    /**
     * Embeds bitmapData and returns an instance of `flash.display.BitmapData`
     */
    macro static public function bitmapData (path:String) : Expr
    {
        var className = __embedBitmap(path);

        return Context.parse('new $className(0, 0)', Context.currentPos());
    }


    /**
     * Description
     */
    macro static public function test () : Expr
    {
        trace(Context.getDefines());

        return macro {};
    }


#if macro

    /**
     * Make canonical path string.
     * Replaces all backslashes with slashes, removes trailing slashes.
     *
     */
    static public function canonicalize (path:String) : String
    {
        path = path.replace('\\', '/').trim();

        if (path.endsWith('/')) {
            var pos = path.length - 2;
            while (path.fastCodeAt(pos) == '/'.code) {
                pos --;
            }
            path = path.substring(0, pos + 1);
        }

        return path;
    }


    /**
     * Get directory of a file for `pos`. If `pos` is not specified returns directory of current context.
     */
    static public function getDirectory (pos:Position = null) : String
    {
        if (pos == null) pos = Context.currentPos();

        var file = Context.getPosInfos(pos).file;
        if (!file.exists()) {
            file = Context.resolvePath(file);
        }
        file = canonicalize(file);

        //remove file name
        var lastSlash = file.lastIndexOf('/');
        if (lastSlash >= 0) {
            file = file.substring(0, lastSlash + 1);
        }

        return file;
    }//function _dir()


    /**
     * Embed specified font under returned class name
     */
    static private function __embedFont (fontPath:String) : String
    {
        var className = __embedded.get(fontPath);
        if (className != null) {
            return className;
        }

        className = __erNonIdentChars.replace(fontPath, '_');
        className = 'EmbeddedFont_$className';

        var dir = getDirectory().absolutePath();
        var definition = macro class Font extends flash.text.Font {}
        definition.pack = ['sx', 'themes', 'embed'];
        definition.name = className;
        definition.meta = [{
            name   : ':font',
            params : [macro $v{dir + fontPath}, macro range=""],
            pos    : Context.currentPos()
        }];

        Context.defineType(definition);

        __embedded.set(fontPath, className);

        return definition.pack.join('.') + '.' + className;
    }


    /**
     * Embed specified bitmap under returned class name
     */
    static private function __embedBitmap (bitmapPath:String) : String
    {
        var className = __embedded.get(bitmapPath);
        if (className != null) {
            return className;
        }

        className = __erNonIdentChars.replace(bitmapPath, '_');
        className = 'EmbeddedBitmap_$className';

        var pos = Context.makePosition({min:0, max:0, file:bitmapPath});
        var dir = getDirectory().absolutePath();
        var definition = macro class Bitmap extends flash.display.BitmapData {}
        definition.pack = ['sx', 'themes', 'embed'];
        definition.name = className;
        definition.meta = [{name:':bitmap', params:[macro @:pos(pos) $v{dir + bitmapPath}], pos:pos}];

        Context.defineType(definition);

        __embedded.set(bitmapPath, className);

        return definition.pack.join('.') + '.' + className;
    }


#else

    /**
     * Description
     */
    static public function loadBitmaps () : Void
    {

    }

#end

}//class Assets