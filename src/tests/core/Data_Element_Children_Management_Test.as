package  tests.core {
    import flexunit.framework.Assert;
    import ro.ciacob.desktop.data.DataElement;
    import tests.helpers.CustomDataElement;

    public class Data_Element_Children_Management_Test {

        private var parent:DataElement;
        private var child1:DataElement;
        private var child2:DataElement;
        private var child3:DataElement;

        [Before]
        public function setUp():void {
            // Initialize parent and children
            parent = new DataElement();
            child1 = new DataElement();
            child2 = new DataElement();
            child3 = new DataElement();
        }

        [After]
        public function tearDown():void {
            // Clean up
            parent = null;
            child1 = null;
            child2 = null;
            child3 = null;
        }

        // Test 1: Add Child
        [Test]
        public function testAddChild():void {
            parent.addDataChild(child1);

            Assert.assertEquals("Parent should have 1 child", 1, parent.numDataChildren);
            Assert.assertStrictlyEquals("Child1's parent should be the parent element", parent, child1.dataParent);
        }

        // Test 2: Add Child at Index
        [Test]
        public function testAddChildAtIndex():void {
            parent.addDataChildAt(child1, 0);
            parent.addDataChildAt(child2, 5); // Index greater than child count, should append
            parent.addDataChildAt(child3, 1); // Insert at index 1

            Assert.assertEquals("Parent should have 3 children", 3, parent.numDataChildren);
            Assert.assertStrictlyEquals("Child1 should be at index 0", child1, parent.getDataChildAt(0));
            Assert.assertStrictlyEquals("Child3 should be at index 1", child3, parent.getDataChildAt(1));
            Assert.assertStrictlyEquals("Child2 should be at index 2", child2, parent.getDataChildAt(2));
        }

        // Test 3: Add Child to an Element That Cannot Have Children
        [Test]
        public function testAddChildToElementThatCannotHaveChildren():void {
            var noChildrenElement:CustomDataElement = new CustomDataElement();
            noChildrenElement.addDataChild(child1);

            Assert.assertEquals("Element should not have any children", 0, noChildrenElement.numDataChildren);
            Assert.assertNull("Child's parent should still be null", child1.dataParent);
        }

        // Test 4: Remove Child
        [Test]
        public function testRemoveChild():void {
            parent.addDataChild(child1);
            var removedChild:DataElement = parent.removeDataChild(child1);

            Assert.assertEquals("Parent should have no children after removal", 0, parent.numDataChildren);
            Assert.assertNull("Child's parent should be null after removal", child1.dataParent);
            Assert.assertStrictlyEquals("Removed child should be returned", child1, removedChild);
        }

        // Test 5: Remove Child at Index
        [Test]
        public function testRemoveChildAtIndex():void {
            parent.addDataChild(child1);
            parent.addDataChild(child2);
            var removedChild:DataElement = parent.removeDataChildAt(0);

            Assert.assertEquals("Parent should have 1 child after removal", 1, parent.numDataChildren);
            Assert.assertStrictlyEquals("Child2 should now be at index 0", child2, parent.getDataChildAt(0));
            Assert.assertStrictlyEquals("Removed child should be child1", child1, removedChild);
        }

        // Test 6: Remove Non-Existent Child
        [Test]
        public function testRemoveNonExistentChild():void {
            var removedChild:DataElement = parent.removeDataChild(child1);

            Assert.assertEquals("Parent should still have no children", 0, parent.numDataChildren);
            Assert.assertNull("Removing a non-existent child should return null", removedChild);
        }

        // Test 7: Get Child Index
        [Test]
        public function testGetChildIndex():void {
            parent.addDataChild(child1);
            parent.addDataChild(child2);
            parent.addDataChild(child3);

            Assert.assertEquals("Index of child1 should be 0", 0, parent.getChildIndex(child1));
            Assert.assertEquals("Index of child2 should be 1", 1, parent.getChildIndex(child2));
            Assert.assertEquals("Index of child3 should be 2", 2, parent.getChildIndex(child3));
        }

        // Test 8: Get Child at Index
        [Test]
        public function testGetChildAtIndex():void {
            parent.addDataChild(child1);
            parent.addDataChild(child2);

            Assert.assertStrictlyEquals("Child at index 0 should be child1", child1, parent.getDataChildAt(0));
            Assert.assertStrictlyEquals("Child at index 1 should be child2", child2, parent.getDataChildAt(1));
        }

        // Test 9: Number of Children
        [Test]
        public function testNumberOfChildren():void {
            parent.addDataChild(child1);
            parent.addDataChild(child2);
            Assert.assertEquals("Parent should have 2 children", 2, parent.numDataChildren);

            parent.removeDataChild(child1);
            Assert.assertEquals("Parent should have 1 child after removal", 1, parent.numDataChildren);
        }

        // Test 10: Empty Children
        [Test]
        public function testEmptyChildren():void {
            parent.addDataChild(child1);
            parent.addDataChild(child2);
            parent.empty();

            Assert.assertEquals("Parent should have no children after empty()", 0, parent.numDataChildren);
        }
    }
}
