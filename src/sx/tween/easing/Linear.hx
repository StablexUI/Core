/**
 * @author Joshua Granick
 * @author Philippe / http://philippe.elsass.me
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */


package sx.tween.easing;


class Linear {


	static public var easeNone (get_easeNone, never):EasingFunction;


	private static function get_easeNone ():EasingFunction {

		return LinearEaseNone.calculate;

	}


}


private class LinearEaseNone {

	static public function calculate (k:Float):Float {

		return k;

	}

}