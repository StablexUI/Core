/**
 * @author Joshua Granick
 * @author Philippe / http://philippe.elsass.me
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */


package sx.tween.easing;


class Quart {


	static public var easeIn (get_easeIn, never):EasingFunction;
	static public var easeInOut (get_easeInOut, never):EasingFunction;
	static public var easeOut (get_easeOut, never):EasingFunction;


	private static function get_easeIn ():EasingFunction {

		return QuartEaseIn.calculate;

	}


	private static function get_easeInOut ():EasingFunction {

		return QuartEaseInOut.calculate;

	}


	private static function get_easeOut ():EasingFunction {

		return QuartEaseOut.calculate;

	}


}


private class QuartEaseIn {

	static public function calculate (k:Float):Float {

		return k * k * k * k;

	}

}


private class QuartEaseInOut {

	static public function calculate (k:Float):Float {

		if ((k *= 2) < 1) return 0.5 * k * k * k * k;
		return -0.5 * ((k -= 2) * k * k * k - 2);

	}

}


private class QuartEaseOut {

	static public function calculate (k:Float):Float {

		return -(--k * k * k * k - 1);

	}

}