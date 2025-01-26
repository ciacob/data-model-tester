package tests.core {
    import flexunit.framework.Assert;
    import ro.ciacob.desktop.data.DataElement;
    import ro.ciacob.utils.Objects;

    public class Data_Element_Constructor_Test {

        private var element:DataElement;

        [After]
        public function tearDown():void {
            // Clean up after each test
            element = null;
        }

        // Test 1: Default Initialization
        [Test]
        public function testDefaultInitialization():void {
            element = new DataElement();
            
            Assert.assertNotNull("Children array should be initialized", element._children);
            Assert.assertEquals("Children array should be empty", 0, element._children.length);

            Assert.assertNotNull("Content object should be initialized", element._content);
            Assert.assertTrue("Content object should be empty", isObjectEmpty(element._content));

            Assert.assertNotNull("Metadata object should be initialized", element._metadata);
            Assert.assertTrue("Metadata object should be empty", isObjectEmpty(element._metadata));

            Assert.assertNull("Flat elements map should initially be null", element._ownFlatElementsMap);
        }

        // Test 2: Initialization with Metadata
        [Test]
        public function testInitializationWithMetadata():void {
            var metadata:Object = { key1: "value1", key2: "value2" };
            element = new DataElement(metadata);

            Assert.assertNotNull("Metadata object should be initialized", element._metadata);
            Assert.assertEquals("Metadata should contain 2 keys", 2, Objects.getKeys(element._metadata).length);
            Assert.assertEquals("Metadata key1 should be 'value1'", "value1", element._metadata["key1"]);
            Assert.assertEquals("Metadata key2 should be 'value2'", "value2", element._metadata["key2"]);
        }

        // Test 3: Initialization with Content
        [Test]
        public function testInitializationWithContent():void {
            var content:Object = { keyA: 123, keyB: "test" };
            element = new DataElement(null, content);

            Assert.assertNotNull("Content object should be initialized", element._content);
            Assert.assertEquals("Content should contain 2 keys", 2, Objects.getKeys(element._content).length);
            Assert.assertEquals("Content keyA should be 123", 123, element._content["keyA"]);
            Assert.assertEquals("Content keyB should be 'test'", "test", element._content["keyB"]);
        }

        // Test 4: Initialization with Both Metadata and Content
        [Test]
        public function testInitializationWithBothMetadataAndContent():void {
            var metadata:Object = { metaKey: "metaValue" };
            var content:Object = { contentKey: "contentValue" };
            element = new DataElement(metadata, content);

            Assert.assertNotNull("Metadata object should be initialized", element._metadata);
            Assert.assertEquals("Metadata metaKey should be 'metaValue'", "metaValue", element._metadata["metaKey"]);

            Assert.assertNotNull("Content object should be initialized", element._content);
            Assert.assertEquals("Content contentKey should be 'contentValue'", "contentValue", element._content["contentKey"]);
        }

        // Test 5: Empty Metadata or Content
        [Test]
        public function testEmptyMetadataOrContent():void {
            var metadata:Object = {};
            var content:Object = {};
            element = new DataElement(metadata, content);

            Assert.assertNotNull("Metadata object should be initialized", element._metadata);
            Assert.assertTrue("Metadata object should be empty", isObjectEmpty(element._metadata));

            Assert.assertNotNull("Content object should be initialized", element._content);
            Assert.assertTrue("Content object should be empty", isObjectEmpty(element._content));
        }

        // Test 6: Null Metadata or Content
        [Test]
        public function testNullMetadataOrContent():void {
            element = new DataElement(null, null);

            Assert.assertNotNull("Metadata object should be initialized as empty", element._metadata);
            Assert.assertTrue("Metadata object should be empty", isObjectEmpty(element._metadata));

            Assert.assertNotNull("Content object should be initialized as empty", element._content);
            Assert.assertTrue("Content object should be empty", isObjectEmpty(element._content));
        }

        // Helper: Check if an object is empty
        private function isObjectEmpty(obj:Object):Boolean {
            for (var key:String in obj) {
                return false;
            }
            return true;
        }
    }
}
