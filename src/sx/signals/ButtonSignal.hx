package sx.signals;

import sx.signals.Signal;
import sx.widgets.Button;


/**
 * Dispatched when user clicks or taps a button.
 *
 * Unlike click signal trigger signal will not be dispatched if:
 *  - user pressed mouse button, moved cursor out of button, then returned it and released mouse button (unless `button.releaseOnPointerOut = false`);
 *
 * @param Button    Triggered button.
 */
typedef ButtonSignal = Signal<Button->Void>;