package tests {
    import flexunit.framework.Assert;
    import ro.ciacob.desktop.data.DataElement;

    public class Data_Element_Content_Tests {

        private var element:DataElement;

        [Before]
        public function set_up():void {
            // Create a fresh DataElement for each test
            element = new DataElement();
        }

        [After]
        public function tear_down():void {
            // Clean up after each test
            element = null;
        }

        // Test 1: Set Content
        [Test]
        public function test__set_content():void {
            element.setContent("key1", "value1");
            element.setContent("key2", 42);

            Assert.assertEquals("Content key1 should be 'value1'", "value1", element.getContent("key1"));
            Assert.assertEquals("Content key2 should be 42", 42, element.getContent("key2"));
        }

        // Test 2: Get Content
        [Test]
        public function test__get_content():void {
            element.setContent("key1", "value1");
            element.setContent("key2", 42);

            Assert.assertEquals("Should retrieve 'value1' for key1", "value1", element.getContent("key1"));
            Assert.assertEquals("Should retrieve 42 for key2", 42, element.getContent("key2"));

            // Test retrieval of a non-existent key
            Assert.assertNull("Should return null for non-existent key", element.getContent("nonExistentKey"));
        }

        // Test 3: Get Content Keys
        [Test]
        public function test__get_content_keys():void {
            element.setContent("keyB", "valueB");
            element.setContent("keyA", "valueA");
            element.setContent("keyC", "valueC");

            var keys:Array = element.getContentKeys();
            Assert.assertEquals("Should return 3 content keys", 3, keys.length);
            Assert.assertEquals("First key should be 'keyA'", "keyA", keys[0]);
            Assert.assertEquals("Second key should be 'keyB'", "keyB", keys[1]);
            Assert.assertEquals("Third key should be 'keyC'", "keyC", keys[2]);
        }

        // Test 4: Remove Content
        [Test]
        public function test__remove_content():void {
            element.setContent("key1", "value1");
            element.setContent("key2", "value2");

            element.removeContent("key1");

            Assert.assertNull("Content key1 should no longer exist", element.getContent("key1"));
            Assert.assertEquals("Content key2 should still exist", "value2", element.getContent("key2"));
        }

        // Test 5: Import Content
        [Test]
        public function test__import_content():void {
            var contentToImport:Object = {
                key1: "value1",
                key2: 42,
                key3: true
            };

            element.importContent(contentToImport);

            Assert.assertEquals("Content key1 should be 'value1'", "value1", element.getContent("key1"));
            Assert.assertEquals("Content key2 should be 42", 42, element.getContent("key2"));
            Assert.assertEquals("Content key3 should be true", true, element.getContent("key3"));
        }

        // Test 6: Import Content Without Overwrite
        [Test]
        public function test__import_content_without_overwrite():void {
            // Set initial content
            element.setContent("key1", "originalValue");
            element.setContent("key2", "originalValue");

            // Import new content
            var contentToImport:Object = {
                key1: "newValue", // Key exists, should not overwrite
                key2: "newValue", // Key exists, should not overwrite
                key3: "newValue"  // New key, should be added
            };

            element.importContent(contentToImport, false); // Overwrite = false

            Assert.assertEquals("Content key1 should retain its original value", "originalValue", element.getContent("key1"));
            Assert.assertEquals("Content key2 should retain its original value", "originalValue", element.getContent("key2"));
            Assert.assertEquals("Content key3 should be added with 'newValue'", "newValue", element.getContent("key3"));
        }
    }
}
