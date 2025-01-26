package tests.core {
    import flexunit.framework.Assert;
    import ro.ciacob.desktop.data.DataElement;

    public class Data_Element_Hierarchy_Navigation_Tests {

        private var root:DataElement;
        private var child1:DataElement;
        private var child2:DataElement;
        private var grandchild1:DataElement;

        [Before]
        public function set_up():void {
            // Create a root DataElement and some children
            root = new DataElement();
            child1 = new DataElement();
            child2 = new DataElement();
            grandchild1 = new DataElement();
        }

        [After]
        public function tear_down():void {
            // Clean up after each test
            root = null;
            child1 = null;
            child2 = null;
            grandchild1 = null;
        }

        // Test 1: Get Parent
        [Test]
        public function test__get_parent():void {
            root.addDataChild(child1);

            Assert.assertStrictlyEquals(
                "Child1's parent should be the root element",
                root,
                child1.dataParent
            );
        }

        // Test 2: Get Root
        [Test]
        public function test__get_root():void {
            root.addDataChild(child1);
            child1.addDataChild(grandchild1);

            Assert.assertStrictlyEquals(
                "The root of the grandchild should be the root element",
                root,
                grandchild1.root
            );

            Assert.assertStrictlyEquals(
                "The root of child1 should be the root element",
                root,
                child1.root
            );

            Assert.assertStrictlyEquals(
                "The root element's root should be itself",
                root,
                root.root
            );
        }

        // Test 3: Get Route
        [Test]
        public function test__get_route():void {
            root.addDataChild(child1);
            root.addDataChild(child2);
            child1.addDataChild(grandchild1);

            Assert.assertEquals(
                "The route of the root should be '-1'",
                "-1",
                root.route
            );

            Assert.assertEquals(
                "The route of child1 should be '-1_0'",
                "-1_0",
                child1.route
            );

            Assert.assertEquals(
                "The route of child2 should be '-1_1'",
                "-1_1",
                child2.route
            );

            Assert.assertEquals(
                "The route of grandchild1 should be '-1_0_0'",
                "-1_0_0",
                grandchild1.route
            );
        }

        // Test 4: Walk
        [Test]
        public function test__walk():void {
            root.addDataChild(child1);
            root.addDataChild(child2);
            child1.addDataChild(grandchild1);

            var visitedNodes:Array = [];

            root.walk(function(node:DataElement):void {
                visitedNodes.push(node);
            });

            Assert.assertEquals(
                "Walk should visit 4 nodes in total (root, child1, child2, grandchild1)",
                4,
                visitedNodes.length
            );

            Assert.assertStrictlyEquals(
                "First visited node should be the root",
                root,
                visitedNodes[0]
            );

            Assert.assertStrictlyEquals(
                "Second visited node should be child1",
                child1,
                visitedNodes[1]
            );

            Assert.assertStrictlyEquals(
                "Third visited node should be grandchild1",
                grandchild1,
                visitedNodes[2]
            );

            Assert.assertStrictlyEquals(
                "Fourth visited node should be child2",
                child2,
                visitedNodes[3]
            );
        }
    }
}
