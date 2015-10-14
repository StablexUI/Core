/**
 * @author Joshua Granick
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */


package sx.tween.easing;


class Sine {


	static public var easeIn (get_easeIn, never):EasingFunction;
	static public var easeInOut (get_easeInOut, never):EasingFunction;
	static public var easeOut (get_easeOut, never):EasingFunction;


	private static function get_easeIn ():EasingFunction {

		return SineEaseIn.calculate;

	}


	private static function get_easeInOut ():EasingFunction {

		return SineEaseInOut.calculate;

	}


	private static function get_easeOut ():EasingFunction {

		return SineEaseOut.calculate;

	}


}


private class SineEaseIn {

	static public function calculate (k:Float):Float {

		return 1 - Math.cos(k * (Math.PI / 2));

	}

}


private class SineEaseInOut {

	static public function calculate (k:Float):Float {

		return - (Math.cos(Math.PI * k) - 1) / 2;

	}

}


private class SineEaseOut {

	static public function calculate (k:Float):Float {

		return Math.sin(k * (Math.PI / 2));

	}

}