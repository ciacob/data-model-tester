package tests {
    import flexunit.framework.Assert;
    import ro.ciacob.desktop.data.DataElement;
    import flash.utils.getQualifiedClassName;

    public class Data_Element_Misc_Tests {

        private var root:DataElement;
        private var child:DataElement;
        private var grandChild:DataElement;
        private var orphan:DataElement;

        [Before]
        public function set_up():void {
            // Set up hierarchy
            root = new DataElement();
            child = new DataElement();
            grandChild = new DataElement();
            orphan = new DataElement(); // Orphaned element

            root.addDataChild(child); // Index 0
            child.addDataChild(grandChild); // Index 0
        }

        [After]
        public function tear_down():void {
            // Clean up after each test
            root = null;
            child = null;
            grandChild = null;
            orphan = null;
        }

        // Test: get level
        [Test]
        public function test__get_level():void {
            Assert.assertEquals("Root level should be 0", 0, root.level);
            Assert.assertEquals("Child level should be 1", 1, child.level);
            Assert.assertEquals("GrandChild level should be 2", 2, grandChild.level);
            Assert.assertEquals("Orphaned element level should be 0", 0, orphan.level);
        }

        // Test: get index
        [Test]
        public function test__get_index():void {
            Assert.assertEquals("Root index should be -1", -1, root.index);
            Assert.assertEquals("Child index should be 0", 0, child.index);
            Assert.assertEquals("GrandChild index should be 0 (it's the first child of its parent)", 0, grandChild.index);
            Assert.assertEquals("Orphaned element index should be -1", -1, orphan.index);
        }

        // Test: hasContentKey
        [Test]
        public function test__has_content_key():void {
            // Add some content to the element
            root.setContent("key1", "value1");
            root.setContent("key2", 42);

            Assert.assertTrue("hasContentKey should return true for existing key1", root.hasContentKey("key1"));
            Assert.assertTrue("hasContentKey should return true for existing key2", root.hasContentKey("key2"));
            Assert.assertFalse("hasContentKey should return false for non-existing key3", root.hasContentKey("key3"));
        }

        // Test: toString
        [Test]
        public function test__to_string():void {
            Assert.assertEquals(
                "toString should return the correct string representation for root",
                "[" + getQualifiedClassName(root) + "] [-1]",
                root.toString()
            );

            Assert.assertEquals(
                "toString should return the correct string representation for child",
                "[" + getQualifiedClassName(child) + "] [-1_0]",
                child.toString()
            );

            Assert.assertEquals(
                "toString should return the correct string representation for grandChild",
                "[" + getQualifiedClassName(grandChild) + "] [-1_0_0]",
                grandChild.toString()
            );

            Assert.assertEquals(
                "toString should return the correct string representation for orphan",
                "[" + getQualifiedClassName(orphan) + "] [null]",
                orphan.toString()
            );
        }
    }
}