package sx.signals;

import sx.signals.Signal;
import sx.widgets.Widget;


/**
 * Signal for parent-child relations between widgets.
 *
 * @param   Null<Widget>    Parent widget.
 * @param   Null<Widget>    Child widget.
 * @param   Int             Child index in display list of parent widget. If parent or child is `null` then index is `0`.
 */
typedef ChildSignal = Signal< Null<Widget> -> Null<Widget> -> Int -> Void >;