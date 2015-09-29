package sx.skins;



/**
 * Abstract which implements shortcut for using registered skins by their names
 *
 */
@:forward
abstract AbstractSkin (Skin) from Skin to Skin
{

    /**
     * Get registered skin by name
     */
    @:from
    static private inline function __byName (name:String) : Null<AbstractSkin>
    {
        return sx.Sx.skin(name);
    }

}//abstract AbstractSkin