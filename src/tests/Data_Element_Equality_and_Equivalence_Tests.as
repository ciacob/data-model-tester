package tests {
    import flexunit.framework.Assert;
    import ro.ciacob.desktop.data.DataElement;

    public class Data_Element_Equality_and_Equivalence_Tests {

        private var element1:DataElement;
        private var element2:DataElement;

        [Before]
        public function set_up():void {
            // Create fresh DataElement instances for each test
            element1 = new DataElement();
            element2 = new DataElement();
        }

        [After]
        public function tear_down():void {
            // Clean up after each test
            element1 = null;
            element2 = null;
        }

        // Test 1: Equality - Identical Instances
        [Test]
        public function test__equality_identical_instances():void {
            // Set up identical metadata, content, and children
            element1.setMetadata("key1", "value1");
            element1.setContent("contentKey", "contentValue");

            element2.setMetadata("key1", "value1");
            element2.setContent("contentKey", "contentValue");

            // Add identical children (different instances with the same content)
            var child1:DataElement = new DataElement();
            child1.setContent("childKey", "childValue");
            element1.addDataChild(child1);

            var child2:DataElement = new DataElement();
            child2.setContent("childKey", "childValue");
            element2.addDataChild(child2);

            Assert.assertTrue("Two identical elements with identical children should be equal", element1.isEqualTo(element2));
        }

        // Test 2: Equality - Different Instances
        [Test]
        public function test__equality_different_instances():void {
            // Set up different metadata, content, or children
            element1.setMetadata("key1", "value1");
            element1.setContent("contentKey", "contentValue");

            element2.setMetadata("key1", "differentValue");
            element2.setContent("differentKey", "differentValue");

            // Add different children
            var child1:DataElement = new DataElement();
            child1.setContent("childKey1", "childValue1");
            element1.addDataChild(child1);

            var child2:DataElement = new DataElement();
            child2.setContent("childKey2", "childValue2");
            element2.addDataChild(child2);

            Assert.assertFalse("Two elements with different content/metadata/children should not be equal", element1.isEqualTo(element2));
        }

        // Test 3: Equivalence - Identical Keys but Different Values
        [Test]
        public function test__equivalence_identical_keys_different_values():void {
            // Set up identical keys but different values
            element1.setContent("key1", "value1");
            element1.setContent("key2", "value2");

            element2.setContent("key1", "differentValue");
            element2.setContent("key2", "anotherDifferentValue");

            // These should be equivalent because the keys are the same
            Assert.assertTrue("Two elements with the same keys (regardless of values) should be equivalent", element1.isEquivalentTo(element2));
        }

        // Test 4: Equivalence - Same Keys and Values in Different Orders
        [Test]
        public function test__equivalence_same_keys_same_values():void {
            // Set up identical keys and values in different orders
            element1.setContent("key1", "value1");
            element1.setContent("key2", "value2");

            element2.setContent("key2", "value2");
            element2.setContent("key1", "value1");

            Assert.assertTrue("Two elements with the same keys and values (in different orders) should be equivalent", element1.isEquivalentTo(element2));
        }
    }
}
