/**
 * @author Joshua Granick
 * @author Zeh Fernando, Nate Chatellier
 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
 */


package sx.tween.easing;


class Back {


	static public var easeIn (get_easeIn, never):EasingFunction;
	static public var easeInOut (get_easeInOut, never):EasingFunction;
	static public var easeOut (get_easeOut, never):EasingFunction;


	private static function get_easeIn ():EasingFunction {

		return new BackEaseIn (1.70158).calculate;

	}


	private static function get_easeInOut ():EasingFunction {

		return new BackEaseInOut (1.70158).calculate;

	}


	private static function get_easeOut ():EasingFunction {

		return new BackEaseOut (1.70158).calculate;

	}


}


class BackEaseIn {


	public var s:Float;


	public function new (s:Float) {

		this.s = s;

	}


	public function calculate (k:Float):Float {

		return k * k * ((s + 1) * k - s);

	}


}


class BackEaseInOut {


	public var s:Float;


	public function new (s:Float) {

		this.s = s;

	}


	public function calculate (k:Float):Float {

		if ((k /= 0.5) < 1) return 0.5 * (k * k * (((s *= (1.525)) + 1) * k - s));
		return 0.5 * ((k -= 2) * k * (((s *= (1.525)) + 1) * k + s) + 2);

	}


}


class BackEaseOut {


	public var s:Float;


	public function new (s:Float) {

		this.s = s;

	}


	public function calculate (k:Float):Float {

		return ((k = k - 1) * k * ((s + 1) * k + s) + 1);

	}


}