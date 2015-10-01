package sx.signals;

import sx.signals.Signal;
import sx.widgets.Widget;


/**
 * Signal for parent-child relations between widgets.
 *
 * @param   Widget      Parent widget.
 * @param   Widget      Child widget.
 * @param   Int         Child index in display list of parent widget.
 */
typedef ChildSignal = Signal<Widget->Widget->Int->Void>;