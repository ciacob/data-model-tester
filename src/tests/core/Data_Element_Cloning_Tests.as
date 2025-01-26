package tests.core {
    import flexunit.framework.Assert;
    import ro.ciacob.desktop.data.DataElement;

    public class Data_Element_Cloning_Tests {

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

        // Test 1: Clone Element
        [Test]
        public function test__clone_element():void {
            // Set metadata and content
            element.setMetadata("metaKey", "metaValue");
            element.setContent("contentKey", "contentValue");

            // Clone the element
            var clonedElement:DataElement = element.clone();

            // Verify that the clone is a new instance
            Assert.assertFalse(
                "Cloned element should not be the same instance as the original",
                element === clonedElement
            );

            // Verify that metadata is copied
            Assert.assertEquals(
                "Cloned element should have the same metadata as the original",
                "metaValue",
                clonedElement.getMetadata("metaKey")
            );

            // Verify that content is copied
            Assert.assertEquals(
                "Cloned element should have the same content as the original",
                "contentValue",
                clonedElement.getContent("contentKey")
            );

            // Verify that changes to the clone do not affect the original
            clonedElement.setMetadata("metaKey", "newMetaValue");
            Assert.assertFalse(
                "Changes to the clone's metadata should not affect the original",
                element.getMetadata("metaKey") == clonedElement.getMetadata("metaKey")
            );

            clonedElement.setContent("contentKey", "newContentValue");
            Assert.assertFalse(
                "Changes to the clone's content should not affect the original",
                element.getContent("contentKey") == clonedElement.getContent("contentKey")
            );
        }

        // Test 2: Clone Element Hierarchy
        [Test]
        public function test__clone_element_hierarchy():void {
            // Create a multi-level hierarchy
            var child1:DataElement = new DataElement();
            child1.setContent("childKey1", "childValue1");

            var child2:DataElement = new DataElement();
            child2.setContent("childKey2", "childValue2");

            var grandchild:DataElement = new DataElement();
            grandchild.setContent("grandchildKey", "grandchildValue");

            child1.addDataChild(grandchild);
            element.addDataChild(child1);
            element.addDataChild(child2);

            // Clone the element
            var clonedElement:DataElement = element.clone();

            // Verify that the clone is a new instance
            Assert.assertFalse(
                "Cloned element should not be the same instance as the original",
                element === clonedElement
            );

            // Verify that the clone has the same number of children
            Assert.assertEquals(
                "Cloned element should have the same number of children as the original",
                element.numDataChildren,
                clonedElement.numDataChildren
            );

            // Verify that children are cloned
            var clonedChild1:DataElement = clonedElement.getDataChildAt(0);
            var clonedChild2:DataElement = clonedElement.getDataChildAt(1);

            Assert.assertNotNull("Cloned child1 should not be null", clonedChild1);
            Assert.assertNotNull("Cloned child2 should not be null", clonedChild2);

            Assert.assertFalse(
                "Cloned child1 should not be the same instance as the original child1",
                child1 === clonedChild1
            );

            Assert.assertFalse(
                "Cloned child2 should not be the same instance as the original child2",
                child2 === clonedChild2
            );

            // Verify that grandchild is cloned
            var clonedGrandchild:DataElement = clonedChild1.getDataChildAt(0);
            Assert.assertNotNull("Cloned grandchild should not be null", clonedGrandchild);
            Assert.assertFalse(
                "Cloned grandchild should not be the same instance as the original grandchild",
                grandchild === clonedGrandchild
            );

            // Verify content of cloned elements
            Assert.assertEquals(
                "Cloned child1 should have the same content as the original",
                "childValue1",
                clonedChild1.getContent("childKey1")
            );

            Assert.assertEquals(
                "Cloned child2 should have the same content as the original",
                "childValue2",
                clonedChild2.getContent("childKey2")
            );

            Assert.assertEquals(
                "Cloned grandchild should have the same content as the original",
                "grandchildValue",
                clonedGrandchild.getContent("grandchildKey")
            );

            // Verify that changes to the cloned hierarchy do not affect the original hierarchy
            clonedChild1.setContent("childKey1", "newChildValue1");
            Assert.assertFalse(
                "Changes to the clone's child1 should not affect the original",
                child1.getContent("childKey1") == clonedChild1.getContent("childKey1")
            );

            clonedGrandchild.setContent("grandchildKey", "newGrandchildValue");
            Assert.assertFalse(
                "Changes to the clone's grandchild should not affect the original",
                grandchild.getContent("grandchildKey") == clonedGrandchild.getContent("grandchildKey")
            );
        }
    }
}