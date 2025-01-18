package tests.helpers {

    import ro.ciacob.desktop.data.DataElement;

    public class CustomDataElement extends DataElement {
        override public function get canHaveChildren():Boolean {
            return false;
        }
    }
}
