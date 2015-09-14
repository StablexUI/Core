package sx.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.Tools;


/**
 * Macros for backend implementations.
 *
 */
class Backend
{
    /** Description */
    static private inline var backendClassPrefix = 'sx.backend.T';


    /**
     * Get type for specified backend class
     */
    macro static public function typeFor (className:Expr) : Type
    {
        var cls  = className.toString();
        var pack = getBackendPackage();

        var type = Context.getType('$pack.$cls');

        // switch (type) {
        //     case TInst(_.get() => cls, _):
        //         for (field in cls.fields.get()) {
        //             trace(field.name);
        //         }
        //     case _:
        // }

        return type;
    }


    /**
     * Compiler initialization macro
     */
    static public function init () : Void
    {
        Context.onTypeNotFound(onTypeNotFound);
    }


    /**
     * Define backend implementation if requested `className` is in backend classes list.
     */
    static public function onTypeNotFound (className:String) : TypeDefinition
    {
        if (className.indexOf(backendClassPrefix) != 0) return null;

        var cls  = className.substr(backendClassPrefix.length);
        var pack = getBackendPackage();

        var aliasPack = className.split('.');
        var aliasName = aliasPack.pop();

        return {
            pack   : aliasPack,
            name   : aliasName,
            pos    : Context.currentPos(),
            kind   : TDAlias(TPath({name:cls, pack:pack.split('.'), params:[]})),
            fields : []
        }
    }


    /**
     * Get package defined by `-D SX_BACKEND=pack.backend`
     */
    static private function getBackendPackage () : String
    {
        var pack = 'sx.backend.dummy';

        if (Context.defined('SX_BACKEND')) {
            pack = Context.definedValue('SX_BACKEND');
        }
        // else if (Context.defined('flash')) {
        //     pack = 'sx.backend.flash';
        // }

        return pack;
    }

}//class Backend
