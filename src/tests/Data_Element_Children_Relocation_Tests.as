package tests {
    import flexunit.framework.Assert;
    import ro.ciacob.desktop.data.DataElement;

    public class Data_Element_Children_Relocation_Tests {

        private var parent:DataElement;
        private var child1:DataElement;
        private var child2:DataElement;
        private var child3:DataElement;

        [Before]
        public function set_up():void {
            // Set up a parent with multiple children
            parent = new DataElement();
            child1 = new DataElement();
            child2 = new DataElement();
            child3 = new DataElement();

            parent.addDataChild(child1); // Index 0
            parent.addDataChild(child2); // Index 1
            parent.addDataChild(child3); // Index 2
        }

        [After]
        public function tear_down():void {
            // Clean up after each test
            parent = null;
            child1 = null;
            child2 = null;
            child3 = null;
        }

        // Test 1: Basic Index Update (doReorderSiblings = false)
        [Test]
        public function test__enforce_index_basic_update():void {
            // Update the index of child2 to 0 without reordering siblings
            child2.enforceIndex(0, false, false);

            Assert.assertEquals("Child2's index should be updated in metadata", 0, child2.index);

            // Verify that the order in the _children array is unchanged
            Assert.assertStrictlyEquals("Child1 should still be the first element in the parent's _children array", child1, parent.getDataChildAt(0));

            Assert.assertStrictlyEquals("Child2 should still be the second element in the parent's _children array", child2, parent.getDataChildAt(1));

            Assert.assertStrictlyEquals("Child3 should still be the third element in the parent's _children array", child3, parent.getDataChildAt(2));
        }

        // Test 2: Sanitize Index with Conflict Resolution (doReorderSiblings = false)
        [Test]
        public function test__enforce_index_with_sanitize_no_reorder():void {
            // Move child1 from index 0 to index 1 without reordering siblings
            child1.enforceIndex(1, false, true);

            Assert.assertEquals("Child1's index should be updated to 1", 1, child1.index);

            Assert.assertEquals("Child2's index should be shifted to 0 to avoid conflict", 0, child2.index);

            Assert.assertEquals("Child3's index should remain unchanged", 2, child3.index);

            // Verify that the order in the _children array is unchanged
            Assert.assertStrictlyEquals("Child1 should still be the first element in the parent's _children array", child1, parent.getDataChildAt(0));

            Assert.assertStrictlyEquals("Child2 should still be the second element in the parent's _children array", child2, parent.getDataChildAt(1));

            Assert.assertStrictlyEquals("Child3 should still be the third element in the parent's _children array", child3, parent.getDataChildAt(2));
        }

        // Test 3: Reordering Siblings (doReorderSiblings = true, sanitizeIndex = true)
        [Test]
        public function test__enforce_index_with_reorder_and_sanitize():void {
            // Move child2 to the first position and reorder siblings
            child2.enforceIndex(0, true, true);

            Assert.assertEquals("Child2's index should be updated to 0", 0, child2.index);

            // Verify that the order of the _children array has been updated
            Assert.assertStrictlyEquals("Child2 should now be the first element in the parent's _children array", child2, parent.getDataChildAt(0));

            Assert.assertStrictlyEquals("Child1 should now be the second element in the parent's _children array", child1, parent.getDataChildAt(1));

            Assert.assertStrictlyEquals("Child3 should remain the third element in the parent's _children array", child3, parent.getDataChildAt(2));
        }

        // Test 4: Testing with out of boundaries values
        [Test]
        public function test__enforce_boundaries_with_reorder_and_sanitize():void {
            // Move child2 to and exceedingly large index
            child2.enforceIndex(100, true, true);
            Assert.assertEquals("Child2's index should be updated to greatest permitted index of 2", 2, child2.index);

            // Verify that the order of the _children array has been updated
            Assert.assertStrictlyEquals("Child2 should now be the last element in the parent's _children array", child2, parent.getDataChildAt(2));

            Assert.assertStrictlyEquals("Child3 should now be the second element in the parent's _children array", child3, parent.getDataChildAt(1));

            Assert.assertStrictlyEquals("Child1 should remain the first element in the parent's _children array", child1, parent.getDataChildAt(0));
        }

        // Test 5: No Changes with Default Parameters
        [Test]
        public function test__enforce_index_no_changes_with_defaults():void {
            // Call enforceIndex() with default parameters
            child2.enforceIndex(1);

            Assert.assertEquals("Child2's index should remain unchanged", 1, child2.index);

            // Verify that the order in the _children array is unchanged
            Assert.assertStrictlyEquals("Child1 should still be the first element in the parent's _children array", child1, parent.getDataChildAt(0));

            Assert.assertStrictlyEquals("Child2 should still be the second element in the parent's _children array", child2, parent.getDataChildAt(1));

            Assert.assertStrictlyEquals("Child3 should still be the third element in the parent's _children array", child3, parent.getDataChildAt(2));
        }
    }
}
