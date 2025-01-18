package tests {
    import flexunit.framework.Assert;
    import ro.ciacob.desktop.data.DataElement;

    public class Data_Element_Edge_Case_Tests {

        private var parent:DataElement;
        private var child:DataElement;

        [Before]
        public function set_up():void {
            // Create a fresh DataElement for each test
            parent = new DataElement();
            child = new DataElement();
        }

        [After]
        public function tear_down():void {
            // Clean up after each test
            parent = null;
            child = null;
        }

        // Test 1: Add Child at Out-of-Bounds Index
        [Test]
        public function test__add_child_at_out_of_bounds_index():void {
            parent.addDataChild(new DataElement()); // Add 1 child for context

            // Add a child at an out-of-bounds index
            parent.addDataChildAt(child, 100); // Should append to the end

            Assert.assertEquals("Child should be appended to the end of the list when added at an out-of-bounds index", 2, parent.numDataChildren);

            Assert.assertStrictlyEquals("The last child should be the one added at the out-of-bounds index", child, parent.getDataChildAt(1));
        }

        // Test 2: Remove Child Not in List
        [Test]
        public function test__remove_child_not_in_list():void {
            var nonExistentChild:DataElement = new DataElement();

            // Attempt to remove a child that was never added
            var result:DataElement = parent.removeDataChild(nonExistentChild);

            Assert.assertNull("Removing a child that does not exist should return null", result);

            Assert.assertEquals("Parent's children list should remain unchanged", 0, parent.numDataChildren);
        }

        // Test 3: Serialization of Invalid Objects
        [Test]
        public function test__serialization_of_invalid_objects():void {
            var invalidObject:Object = {customFunction: function():void {
            }};

            // Attempt to set non-AMF3-compatible content
            var result:Boolean = parent.setContent("key", invalidObject);

            // Verify that setContent() returns false
            Assert.assertFalse("setContent() should return false for non-AMF3-compatible content", result);

            // Verify that the key was not added to _content
            Assert.assertNull("Non-AMF3-compatible content should not be added to _content", parent.getContent("key"));
        }


        // Test 4: Circular References
        [Test]
        public function test__circular_references():void {
            // TODO: review this test
            var child1:DataElement = new DataElement();
            var child2:DataElement = new DataElement();

            // Create a basic hierarchy
            parent.addDataChild(child1);
            child1.addDataChild(child2);

            // Attempt to create a circular reference by adding `parent` as a child of `child2`
            try {
                child2.addDataChild(parent);
                Assert.fail("Adding an ancestor as a child should not be allowed");
            } catch (error:Error) {
                Assert.assertTrue("An error should be thrown when attempting to create a circular reference", error is Error);
            }

            // Verify that the hierarchy is still intact and uncorrupted
            Assert.assertStrictlyEquals("Child2's parent should remain child1", child1, child2.dataParent);

            Assert.assertStrictlyEquals("Child1's parent should remain the parent element", parent, child1.dataParent);
        }
    }
}
