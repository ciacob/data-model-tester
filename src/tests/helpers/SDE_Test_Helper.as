package tests.helpers {
    import ro.ciacob.desktop.data.SelectableDataElement;

    public class SDE_Test_Helper extends SelectableDataElement {
        public function SDE_Test_Helper(normalizeSelection:Boolean = false) {
            super(normalizeSelection);
        }

        // Exposing protected methods for testing
        public function exposed_doNormalization(rawSet:Array):Array {
            return _doNormalization(rawSet);
        }
    }
}
