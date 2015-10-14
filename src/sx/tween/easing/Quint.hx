/**
 * @author Joshua Granick
 * @author Philippe / http://philippe.elsass.me
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */


package sx.tween.easing;


class Quint {


	static public var easeIn (get_easeIn, never):EasingFunction;
	static public var easeInOut (get_easeInOut, never):EasingFunction;
	static public var easeOut (get_easeOut, never):EasingFunction;


	private static function get_easeIn ():EasingFunction {

		return QuintEaseIn.calculate;

	}


	private static function get_easeInOut ():EasingFunction {

		return QuintEaseInOut.calculate;

	}


	private static function get_easeOut ():EasingFunction {

		return QuintEaseOut.calculate;

	}


}


private class QuintEaseIn {

	static public function calculate (k:Float):Float {

		return k * k * k * k * k;

	}

}


private class QuintEaseInOut {

	static public function calculate (k:Float):Float {

		if ((k *= 2) < 1) return 0.5 * k * k * k * k * k;
		return 0.5 * ((k -= 2) * k * k * k * k + 2);

	}

}


private class QuintEaseOut {

	static public function calculate (k:Float):Float {

		return --k * k * k * k * k + 1;

	}

}