package ;

import hunit.TestCase;
import sx.backend.dummy.BackendFactory;
import sx.Sx;


/**
 * Test case which uses dummy StablexUI backend
 *
 */
class DummyBackendCase extends TestCase
{

    /**
     * Set backend
     */
    override public function setup () : Void
    {
        Sx.setBackendFactory(new BackendFactory());
    }


    /**
     * Destroy backend
     */
    override public function tearDown () : Void
    {
        Sx.setBackendFactory(null);
    }

}//class DummyBackendCase