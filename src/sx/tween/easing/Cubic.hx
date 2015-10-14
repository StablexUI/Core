/**
 * @author Joshua Granick
 * @author Philippe / http://philippe.elsass.me
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */


package sx.tween.easing;


class Cubic {


	static public var easeIn (get_easeIn, never):EasingFunction;
	static public var easeInOut (get_easeInOut, never):EasingFunction;
	static public var easeOut (get_easeOut, never):EasingFunction;


	private static function get_easeIn ():EasingFunction {

		return CubicEaseIn.calculate;

	}


	private static function get_easeInOut ():EasingFunction {

		return CubicEaseInOut.calculate;

	}


	private static function get_easeOut ():EasingFunction {

		return CubicEaseOut.calculate;

	}


}


private class CubicEaseIn {


	static public function calculate (k:Float):Float {

		return k * k * k;

	}

}


private class CubicEaseInOut {


	static public function calculate (k:Float):Float {

		return ((k /= 1 / 2) < 1) ? 0.5 * k * k * k : 0.5 * ((k -= 2) * k * k + 2);

	}


	public function ease (t:Float, b:Float, c:Float, d:Float):Float {

		return ((t /= d / 2) < 1) ? c / 2 * t * t * t + b : c / 2 * ((t -= 2) * t * t + 2) + b;

	}


}


private class CubicEaseOut {


	static public function calculate (k:Float):Float {

		return --k * k * k + 1;

	}

}