package sx.signals;

import sx.widgets.Popup;


/**
 * Dispatched when popup is shown or closed.
 *
 * @param   Popup
 */
typedef SizeSignal = Signal<Popup->Void>;