package sx.signals;

import sx.signals.Signal;
import sx.widgets.Widget;


/**
 * Signal for parent-child relations between widgets.
 *
 * @param   Null<Widget>    Parent widget.
 * @param   Widget          Child widget.
 */
typedef ChildSignal = Signal< Null<Widget> -> Widget -> Void >;