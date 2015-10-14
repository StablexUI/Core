/**
 * @author Joshua Granick
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */


package sx.tween.easing;



class Expo {


	static public var easeIn (get_easeIn, never):EasingFunction;
	static public var easeInOut (get_easeInOut, never):EasingFunction;
	static public var easeOut (get_easeOut, never):EasingFunction;


	private static function get_easeIn ():EasingFunction {

		return ExpoEaseIn.calculate;

	}


	private static function get_easeInOut ():EasingFunction {

		return ExpoEaseInOut.calculate;

	}


	private static function get_easeOut ():EasingFunction {

		return ExpoEaseOut.calculate;

	}


}


private class ExpoEaseIn {

	static public function calculate (k:Float):Float {

		return k == 0 ? 0 : Math.pow(2, 10 * (k - 1));

	}

}


private class ExpoEaseInOut {

	static public function calculate (k:Float):Float {

		if (k == 0) { return 0; }
		if (k == 1) { return 1; }
		if ((k /= 1 / 2.0) < 1.0) {
			return 0.5 * Math.pow(2, 10 * (k - 1));
		}
		return 0.5 * (2 - Math.pow(2, -10 * --k));

	}

}


private class ExpoEaseOut {

	static public function calculate (k:Float):Float {

		return k == 1 ? 1 : (1 - Math.pow(2, -10 * k));

	}

}