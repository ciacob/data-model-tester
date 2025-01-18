package tests {
    import flexunit.framework.Assert;
    import ro.ciacob.desktop.data.DataElement;

    public class DataElementTest {

        private var element:DataElement;

        [Before]
        public function setUp():void {
            // Initialize before each test
            element = new DataElement();
        }

        [After]
        public function tearDown():void {
            // Clean up after each test
            element = null;
        }

        [Test]
        public function testAddChild():void {
            var child:DataElement = new DataElement();
            element.addDataChild(child);

            Assert.assertEquals("Element should have one child", 1, element.numDataChildren);
        }

        [Test]
        public function testMetadata():void {
            element.setMetadata("key", "value");
            Assert.assertEquals("Metadata should return correct value", "value", element.getMetadata("key"));
        }
    }
}
