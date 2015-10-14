/**
 * @author Joshua Granick
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */


package sx.tween.easing;



class Quad {


	static public var easeIn (get_easeIn, never):EasingFunction;
	static public var easeInOut (get_easeInOut, never):EasingFunction;
	static public var easeOut (get_easeOut, never):EasingFunction;


	private static function get_easeIn ():EasingFunction {

		return QuadEaseIn.calculate;

	}


	private static function get_easeInOut ():EasingFunction {

		return QuadEaseInOut.calculate;

	}


	private static function get_easeOut ():EasingFunction {

		return QuadEaseOut.calculate;

	}


}


private class QuadEaseIn {

	public function calculate (k:Float):Float {

		return k * k;

	}

}


private class QuadEaseInOut {

	public function calculate (k:Float):Float {

		if ((k *= 2) < 1) {
			return 1 / 2 * k * k;
		}
		return -1 / 2 * ((k - 1) * (k - 3) - 1);

	}

}


private class QuadEaseOut {

	public function calculate (k:Float):Float {

		return -k * (k - 2);

	}

}