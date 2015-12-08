package sx.signals;

import sx.widgets.Callout;


/**
 * Dispatched when callout widget is shown or closed.
 *
 * @param   Callout
 */
typedef CalloutSignal = Signal<Callout->Void>;