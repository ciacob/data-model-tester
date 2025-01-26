package tests.core {
    import flexunit.framework.Assert;
    import ro.ciacob.desktop.data.DataElement;

    public class Data_Element_Flat_Map_Tests {

        private var root:DataElement;
        private var child1:DataElement;
        private var child2:DataElement;
        private var grandChild1:DataElement;
        private var grandChild2:DataElement;

        [Before]
        public function set_up():void {
            // Set up a hierarchy of elements
            root = new DataElement();
            child1 = new DataElement();
            child2 = new DataElement();
            grandChild1 = new DataElement();
            grandChild2 = new DataElement();

            // Build the hierarchy
            root.addDataChild(child1); // Index 0
            root.addDataChild(child2); // Index 1
            child1.addDataChild(grandChild1); // Index 0
            child2.addDataChild(grandChild2); // Index 0
        }

        [After]
        public function tear_down():void {
            // Clean up after each test
            root = null;
            child1 = null;
            child2 = null;
            grandChild1 = null;
            grandChild2 = null;
        }

        // Test 1: Verify that all elements in the hierarchy share the same parentFlatElementsMap
        [Test]
        public function test__shared_parent_flat_elements_map():void {
            var rootMap:Object = root.parentFlatElementsMap;

            Assert.assertStrictlyEquals(
                "Child1 should share the same parentFlatElementsMap as the root",
                rootMap,
                child1.parentFlatElementsMap
            );

            Assert.assertStrictlyEquals(
                "Child2 should share the same parentFlatElementsMap as the root",
                rootMap,
                child2.parentFlatElementsMap
            );

            Assert.assertStrictlyEquals(
                "GrandChild1 should share the same parentFlatElementsMap as the root",
                rootMap,
                grandChild1.parentFlatElementsMap
            );

            Assert.assertStrictlyEquals(
                "GrandChild2 should share the same parentFlatElementsMap as the root",
                rootMap,
                grandChild2.parentFlatElementsMap
            );
        }

        // Test 2: Verify that all elements are correctly represented in the parentFlatElementsMap by their route
        [Test]
        public function test__elements_correctly_represented_in_flat_map():void {
            // Retrieve the flat map from any element (since it's shared)
            var flatMap:Object = root.parentFlatElementsMap;

            // Verify the routes of each element
            Assert.assertStrictlyEquals(
                "Root should be represented in the flat map at route '-1'",
                root,
                flatMap[root.route]
            );

            Assert.assertStrictlyEquals(
                "Child1 should be represented in the flat map at its route",
                child1,
                flatMap[child1.route]
            );

            Assert.assertStrictlyEquals(
                "Child2 should be represented in the flat map at its route",
                child2,
                flatMap[child2.route]
            );

            Assert.assertStrictlyEquals(
                "GrandChild1 should be represented in the flat map at its route",
                grandChild1,
                flatMap[grandChild1.route]
            );

            Assert.assertStrictlyEquals(
                "GrandChild2 should be represented in the flat map at its route",
                grandChild2,
                flatMap[grandChild2.route]
            );

            // Use getElementByRoute() for verification
            Assert.assertStrictlyEquals(
                "getElementByRoute should retrieve Root using its route",
                root,
                root.getElementByRoute(root.route)
            );

            Assert.assertStrictlyEquals(
                "getElementByRoute should retrieve Child1 using its route",
                child1,
                root.getElementByRoute(child1.route)
            );

            Assert.assertStrictlyEquals(
                "getElementByRoute should retrieve Child2 using its route",
                child2,
                root.getElementByRoute(child2.route)
            );

            Assert.assertStrictlyEquals(
                "getElementByRoute should retrieve GrandChild1 using its route",
                grandChild1,
                root.getElementByRoute(grandChild1.route)
            );

            Assert.assertStrictlyEquals(
                "getElementByRoute should retrieve GrandChild2 using its route",
                grandChild2,
                root.getElementByRoute(grandChild2.route)
            );
        }
    }
}
