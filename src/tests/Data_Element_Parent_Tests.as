package tests {
    import flexunit.framework.Assert;
    import ro.ciacob.desktop.data.DataElement;

    public class Data_Element_Parent_Tests {

        private var root:DataElement;
        private var child:DataElement;
        private var grandChild:DataElement;

        [Before]
        public function set_up():void {
            root = new DataElement();
            child = new DataElement();
            grandChild = new DataElement();

            root.addDataChild(child);
            child.addDataChild(grandChild);
        }

        [After]
        public function tear_down():void {
            root = null;
            child = null;
            grandChild = null;
        }

        // Test 1: Basic Parent Setting
        [Test]
        public function test__basic_parent_setting():void {
            var newParent:DataElement = new DataElement();

            // Set a new parent for the child
            var success:Boolean = child.setParent(newParent);

            Assert.assertTrue("Setting a valid parent should succeed", success);
            Assert.assertStrictlyEquals("Child's dataParent should be updated to the new parent", newParent, child.dataParent);

            // Verify metadata updates
            Assert.assertEquals("Child's route should reflect the new parent", "-1_0", child.route);
        }

        // Test 2: Null Parent
        [Test]
        public function test__null_parent():void {
            // Set null as the parent for the child
            var success:Boolean = child.setParent(null);

            Assert.assertTrue("Setting null as the parent should succeed", success);
            Assert.assertNull("Child's dataParent should be cleared", child.dataParent);

            // Verify metadata updates
            Assert.assertEquals("Child's route should be reset as an orphan", "-1", child.route);
        }

        // Test 3: Cyclic Reference Prevention
        [Test]
        public function test__cyclic_reference_prevention():void {
            // Attempt to set a descendant (grandChild) as the parent of an ancestor (root)
            var success:Boolean = root.setParent(grandChild);

            Assert.assertFalse("Setting a descendant as the parent should fail", success);
            Assert.assertStrictlyEquals("Root's parent should remain unchanged", null, root.dataParent);
        }

        // Test 5: Skipping Metadata Reset
        [Test]
        public function test__skipping_metadata_reset():void {
            var newParent:DataElement = new DataElement();

            // Set a new parent for the child, skipping metadata reset
            var success:Boolean = child.setParent(newParent, true, false);

            Assert.assertTrue("Setting a valid parent should succeed", success);
            Assert.assertStrictlyEquals("Child's dataParent should be updated to the new parent", newParent, child.dataParent);

            // Verify metadata was not recalculated
            Assert.assertFalse("Child's route should not be recalculated when doResetMeta = false", (newParent.route + "_0") == child.route);
        }
    }
}
