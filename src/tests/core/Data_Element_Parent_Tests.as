package tests.core {
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
            child.setParent(newParent);

            Assert.assertStrictlyEquals("Child's dataParent should be updated to the new parent", newParent, child.dataParent);

            // Verify metadata updates
            Assert.assertEquals("Child's route should reflect the new parent", "-1_0", child.route);
        }
    }
}
