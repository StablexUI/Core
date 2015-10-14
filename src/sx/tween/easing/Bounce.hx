
/**
 * @author Erik Escoffier
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */


package sx.tween.easing;


class Bounce {

	static public var easeIn (get_easeIn, never):EasingFunction;
	static public var easeInOut (get_easeInOut, never):EasingFunction;
	static public var easeOut (get_easeOut, never):EasingFunction;


	private static function get_easeIn ():EasingFunction {

		return BounceEaseIn.calculate;

	}


	private static function get_easeInOut ():EasingFunction {

		return BounceEaseInOut.calculate;

	}


	private static function get_easeOut ():EasingFunction {

		return BounceEaseOut.calculate;

	}


}




private class BounceEaseIn {

	static public function calculate (k:Float):Float {
		return BounceEaseIn._ease(k,0,1,1);
	}


	public static inline function _ease  (t:Float, b:Float, c:Float, d:Float):Float {
		return c - BounceEaseOut._ease (d-t, 0, c, d) + b;
	}
}



private class BounceEaseInOut {


	static public function calculate (k:Float):Float {

		if (k < .5) {
			return BounceEaseIn._ease(k*2, 0, 1, 1) * .5;
		} else {
			return BounceEaseOut._ease(k*2-1, 0, 1, 1) * .5 + 1*.5;
		}
	}

}





private class BounceEaseOut {

	static public function calculate (k:Float):Float {

		return BounceEaseOut._ease(k,0,1,1);

	}


	public static inline function _ease(t:Float, b:Float, c:Float, d:Float):Float 	{
		if ((t/=d) < (1/2.75)) {
			return c*(7.5625*t*t) + b;
		} else if (t < (2/2.75)) {
			return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
		} else if (t < (2.5/2.75)) {
			return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
		} else {
			return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
		}
	}

}

