package tests.core {
    import flexunit.framework.Assert;
    import ro.ciacob.desktop.data.DataElement;
    import ro.ciacob.desktop.data.constants.DataKeys;

    public class Data_Element_Metadata_Tests {

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

        // Test 1: Set Metadata
        [Test]
        public function test__set_metadata():void {
            element.setMetadata("key1", "value1");
            element.setMetadata("key2", 42);

            Assert.assertEquals("Metadata key1 should be 'value1'", "value1", element.getMetadata("key1"));
            Assert.assertEquals("Metadata key2 should be 42", 42, element.getMetadata("key2"));
        }

        // Test 2: Get Metadata
        [Test]
        public function test__get_metadata():void {
            element.setMetadata("key1", "value1");
            element.setMetadata("key2", 42);

            Assert.assertEquals("Should retrieve 'value1' for key1", "value1", element.getMetadata("key1"));
            Assert.assertEquals("Should retrieve 42 for key2", 42, element.getMetadata("key2"));
        }

        // Test 3: Get Metadata Keys
        [Test]
        public function test__get_metadata_keys():void {
            element.setMetadata("keyB", "valueB");
            element.setMetadata("keyA", "valueA");
            element.setMetadata("keyC", "valueC");

            var keys:Array = element.getMetaKeys();

            Assert.assertContained("'keyA' should be included", "keyA", keys);
            Assert.assertContained("'keyB' should be included", "keyB", keys);
            Assert.assertContained("'keyC' should be included", "keyC", keys);
        }

        // Test 4: Prevent Setting Read-Only Metadata
        [Test]
        public function test__prevent_setting_read_only_metadata():void {
            // Attempt to set a read-only metadata key
            element.setMetadata(DataKeys.CHILDREN, "readOnlyValue");

            // Verify that the key was not stored in _metadata
            Assert.assertNull("Should not allow setting read-only metadata", element.getMetadata(DataKeys.CHILDREN));
        }

        // Test 5: Intrinsic Metadata Update
        [Test]
        public function test__intrinsic_metadata_update():void {
            // Directly manipulate _children (bypassing addDataChild)
            var child:DataElement = new DataElement();
            var grandchild:DataElement = new DataElement();
            element._children.push(child); // Manually add child
            child.setParent(element);
            child._children.push(grandchild); // Manually add grandchild
            grandchild.setParent(child);

            // At this point, metadata is likely incorrect or empty
            Assert.assertNull("Child's route should be null initially", child.route);
            Assert.assertNull("Grandchild's route should be null initially", grandchild.route);
            Assert.assertEquals("Child's level should be -1 initially", -1, child.level);
            Assert.assertEquals("Grandchild's level should be -1 initially", -1, grandchild.level);

            // Call resetIntrinsicMeta to fix the metadata
            element.resetIntrinsicMeta();

            // Verify metadata after reset
            Assert.assertEquals("Root element's route should be '-1'", "-1", element.route);
            Assert.assertEquals("Root element's level should be 0", 0, element.level);

            Assert.assertEquals("Child's route should be '-1_0'", "-1_0", child.route);
            Assert.assertEquals("Child's level should be 1", 1, child.level);

            Assert.assertEquals("Grandchild's route should be '-1_0_0'", "-1_0_0", grandchild.route);
            Assert.assertEquals("Grandchild's level should be 2", 2, grandchild.level);
        }

    }
}
