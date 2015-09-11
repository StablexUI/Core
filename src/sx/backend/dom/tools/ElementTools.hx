package sx.backend.dom.tools;

import js.html.DOMElement;
import sx.geom.Matrix;


/**
 * Allowed values for `display` css property
 *
 */
@:enum abstract CssDisplay(String) to String
{
    var Block = 'block';
    var None = 'none';
}//abstract CssDisplay


/**
 * Tools to deal with dom elments
 *
 */
class ElementTools
{
    /**
     * Change `postion` css property to `absolute`
     *
     */
    static public inline function initialize (node:DOMElement) : Void
    {
        node.setAttribute('style', 'position:absolute;padding:0px;border:0px;margin:0px;width:0px;height:0px;display:block;');
    }


    /**
     * Set node size
     *
     */
    static public inline function setSize (node:DOMElement, width:Float, height:Float) : Void
    {
        node.style.width  = '${width}px';
        node.style.height = '${height}px';
    }

    /**
     * Change element visibility
     *
     */
    static public inline function setVisible (node:DOMElement, visible:Bool) : Void
    {
        node.style.display = (visible ? Block : None);
    }


    /**
     * Apply transformation matrix
     *
     */
    static public inline function transform (node:DOMElement, matrix:Matrix) : Void
    {
        node.style.transform = 'matrix(${matrix.a}, ${matrix.c}, ${matrix.b}, ${matrix.d}, ${matrix.tx}, ${matrix.ty})';
    }


    /**
     * Change opacity of the `node`
     *
     */
    static public inline function setAlpha (node:DOMElement, alpha:Float) : Void
    {
        node.style.opacity = '$alpha';
    }

}//class ElementTools