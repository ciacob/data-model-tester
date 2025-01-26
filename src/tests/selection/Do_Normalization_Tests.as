package tests.selection {
    import flexunit.framework.Assert;
    import tests.helpers.SDE_Test_Helper;

    public class Do_Normalization_Tests {
        private var root:SDE_Test_Helper;

        [Before]
        public function setUp():void {
            // Create the hierarchy
            root = new SDE_Test_Helper(true);

            // Level 1
            var child1:SDE_Test_Helper = new SDE_Test_Helper(true);
            var child2:SDE_Test_Helper = new SDE_Test_Helper(true);
            var child3:SDE_Test_Helper = new SDE_Test_Helper(true);
            root.addDataChild(child1);
            root.addDataChild(child2);
            root.addDataChild(child3);

            // Level 2
            var grandchild1_1:SDE_Test_Helper = new SDE_Test_Helper(true);
            var grandchild1_2:SDE_Test_Helper = new SDE_Test_Helper(true);
            child1.addDataChild(grandchild1_1);
            child1.addDataChild(grandchild1_2);

            var grandchild2_1:SDE_Test_Helper = new SDE_Test_Helper(true);
            var grandchild2_2:SDE_Test_Helper = new SDE_Test_Helper(true);
            child2.addDataChild(grandchild2_1);
            child2.addDataChild(grandchild2_2);

            var grandchild3_1:SDE_Test_Helper = new SDE_Test_Helper(true);
            var grandchild3_2:SDE_Test_Helper = new SDE_Test_Helper(true);
            var grandchild3_3:SDE_Test_Helper = new SDE_Test_Helper(true);
            child3.addDataChild(grandchild3_1);
            child3.addDataChild(grandchild3_2);
            child3.addDataChild(grandchild3_3);

            // Level 3+
            var grandchild2_1_1:SDE_Test_Helper = new SDE_Test_Helper(true);
            var grandchild2_1_2:SDE_Test_Helper = new SDE_Test_Helper(true);
            grandchild2_1.addDataChild(grandchild2_1_1);
            grandchild2_1.addDataChild(grandchild2_1_2);

            var grandchild3_3_1:SDE_Test_Helper = new SDE_Test_Helper(true);
            var grandchild3_3_2:SDE_Test_Helper = new SDE_Test_Helper(true);
            var grandchild3_3_3:SDE_Test_Helper = new SDE_Test_Helper(true);
            grandchild3_3.addDataChild(grandchild3_3_1);
            grandchild3_3.addDataChild(grandchild3_3_2);
            grandchild3_3.addDataChild(grandchild3_3_3);

            var grandchild3_3_3_1:SDE_Test_Helper = new SDE_Test_Helper(true);
            var grandchild3_3_3_2:SDE_Test_Helper = new SDE_Test_Helper(true);
            grandchild3_3_3.addDataChild(grandchild3_3_3_1);
            grandchild3_3_3.addDataChild(grandchild3_3_3_2);
        }

        [After]
        public function tearDown():void {
            root = null;
        }

        // Test 1: Single element normalization
        [Test]
        public function test__do_normalization_single_element():void {
            var input:Array = [root.getDataChildAt(0)]; // child1
            var output:Array = root.exposed_doNormalization(input);
            Assert.assertEquals("Normalization with a single element should return the same element", 1, output.length);
            Assert.assertStrictlyEquals("Normalization should return the exact same element", input[0], output[0]);
        }

        // Test 2: Multiple siblings, no normalization needed
        [Test]
        public function test__do_normalization_sorted_output():void {
            // Input: child2, child1 (out of order)
            var input:Array = [root.getDataChildAt(1), root.getDataChildAt(0)]; // child2, child1

            // Perform normalization
            var output:Array = root.exposed_doNormalization(input);

            // Expected output: child1, child2 (in depth-first traversal order)
            Assert.assertEquals("Normalization should not alter the number of elements", input.length, output.length);
            Assert.assertStrictlyEquals("Normalization should sort elements into depth-first traversal order", root.getDataChildAt(0), output[0]); // child1
            Assert.assertStrictlyEquals("Normalization should sort elements into depth-first traversal order", root.getDataChildAt(1), output[1]); // child2
        }

        // Test 3: Normalize to deepest level
        [Test]
        public function test__do_normalization_to_deepest_level():void {
            var input:Array = [root.getDataChildAt(0), root.getDataChildAt(2).getDataChildAt(2)]; // child1, grandchild3.3
            var output:Array = root.exposed_doNormalization(input);
            Assert.assertEquals("Normalization should expand to the deepest level descendants", 3, output.length);
            Assert.assertStrictlyEquals("Normalization should include grandchild1.1", root.getDataChildAt(0).getDataChildAt(0), output[0]);
            Assert.assertStrictlyEquals("Normalization should include grandchild1.2", root.getDataChildAt(0).getDataChildAt(1), output[1]);
            Assert.assertStrictlyEquals("Normalization should include grandchild3.3", root.getDataChildAt(2).getDataChildAt(2), output[2]);
        }

        // Test 4: Orphans should be ignored
        [Test]
        public function test__do_normalization_with_orphans():void {
            var orphan:SDE_Test_Helper = new SDE_Test_Helper(true);
            var input:Array = [orphan, root.getDataChildAt(1)]; // orphan, child2
            var output:Array = root.exposed_doNormalization(input);
            Assert.assertEquals("Normalization should ignore orphans", 1, output.length);
            Assert.assertStrictlyEquals("Normalization should keep valid elements only", root.getDataChildAt(1), output[0]);
        }

        // Test 5: Complex mix of ancestors and descendants with refined normalization logic
        [Test]
        public function test__do_normalization_with_refined_logic():void {
            // Input: [child1, grandchild1.2, child2]
            var input:Array = [root.getDataChildAt(0), root.getDataChildAt(0).getDataChildAt(1), root.getDataChildAt(1)]; // child1, grandchild1.2, child2

            // Perform normalization
            var output:Array = root.exposed_doNormalization(input);

            // Expected output: [grandchild1.2, grandchild2.1, grandchild2.2]
            Assert.assertEquals("Normalization should include only level-2 descendants, respecting refined rules", 3, output.length);
            Assert.assertStrictlyEquals("Normalization should include grandchild1.2", root.getDataChildAt(0).getDataChildAt(1), output[0]);
            Assert.assertStrictlyEquals("Normalization should include grandchild2.1", root.getDataChildAt(1).getDataChildAt(0), output[1]);
            Assert.assertStrictlyEquals("Normalization should include grandchild2.2", root.getDataChildAt(1).getDataChildAt(1), output[2]);
        }

        // Test 6: Ancestor with one descendant already in the input
        [Test]
        public function test__do_normalization_ancestor_with_descendant_in_input():void {
            // Input: [child1, grandchild1.2]
            var input:Array = [root.getDataChildAt(0), root.getDataChildAt(0).getDataChildAt(1)]; // child1, grandchild1.2

            // Perform normalization
            var output:Array = root.exposed_doNormalization(input);

            // Expected output: [grandchild1.2]
            Assert.assertEquals("Normalization should keep only the explicitly provided descendant", 1, output.length);
            Assert.assertStrictlyEquals("Normalization should include grandchild1.2", root.getDataChildAt(0).getDataChildAt(1), output[0]);
        }

        // Test 7: Ancestor with multiple descendants
        [Test]
        public function test__do_normalization_partial_descendants_in_input():void {
            // Input: [child3, grandchild3.1, grandchild3.3.1]
            var input:Array = [
                    root.getDataChildAt(2), // child3
                    root.getDataChildAt(2).getDataChildAt(0), // grandchild3.1
                    root.getDataChildAt(2).getDataChildAt(2).getDataChildAt(0) // grandchild3.3.1
                ];

            // Perform normalization
            var output:Array = root.exposed_doNormalization(input);

            // Expected output: [grandchild3.3.1]
            Assert.assertEquals(
                    "Normalization should collapse to the deepest explicitly provided descendant",
                    1,
                    output.length
                );
            Assert.assertStrictlyEquals(
                    "Normalization should include only grandchild3.3.1",
                    root.getDataChildAt(2).getDataChildAt(2).getDataChildAt(0),
                    output[0]
                );
        }

        // Test 8: Ancestor with one specific deeply nested descendant in the input
        [Test]
        public function test__do_normalization_deep_descendant_in_input():void {
            // Input: [child2, grandchild2.1.2]
            var input:Array = [
                    root.getDataChildAt(1), // child2
                    root.getDataChildAt(1).getDataChildAt(0).getDataChildAt(1) // grandchild2.1.2
                ];

            // Perform normalization
            var output:Array = root.exposed_doNormalization(input);

            // Expected output: [grandchild2.1.2]
            Assert.assertEquals("Normalization should keep only the explicitly provided deeply nested descendant", 1, output.length);
            Assert.assertStrictlyEquals("Normalization should include grandchild2.1.2", root.getDataChildAt(1).getDataChildAt(0).getDataChildAt(1), output[0]);
        }

        // Test 9: Multiple elements from different branches with one deepest element
        [Test]
        public function test__do_normalization_deepest_single_element():void {
            // Input: child1, grandchild1.1, grandchild2.1.2, grandchild3.3.2, grandchild3.3.3.2
            var input:Array = [
                    root.getDataChildAt(0), // child1
                    root.getDataChildAt(0).getDataChildAt(0), // grandchild1.1
                    root.getDataChildAt(1).getDataChildAt(0).getDataChildAt(1), // grandchild2.1.2
                    root.getDataChildAt(2).getDataChildAt(2).getDataChildAt(1), // grandchild3.3.2
                    root.getDataChildAt(2).getDataChildAt(2).getDataChildAt(2).getDataChildAt(1) // grandchild3.3.3.2
                ];

            // Perform normalization
            var output:Array = root.exposed_doNormalization(input);

            // Expected output: grandchild3.3.3.2
            Assert.assertEquals("Normalization should include only the deepest single element", 1, output.length);
            Assert.assertStrictlyEquals("Normalization should include grandchild3.3.3.2", root.getDataChildAt(2).getDataChildAt(2).getDataChildAt(2).getDataChildAt(1), output[0]);
        }

        // Test 10: Multiple branches with normalization to common deep level
        [Test]
        public function test__do_normalization_multiple_branches():void {
            // Input: grandchild3.3, grandchild2.1.2, grandchild1.2
            var input:Array = [
                    root.getDataChildAt(2).getDataChildAt(2), // grandchild3.3
                    root.getDataChildAt(1).getDataChildAt(0).getDataChildAt(1), // grandchild2.1.2
                    root.getDataChildAt(0).getDataChildAt(1) // grandchild1.2
                ];

            // Perform normalization
            var output:Array = root.exposed_doNormalization(input);

            // Expected output: grandchild2.1.2, grandchild3.3.1, grandchild3.3.2, grandchild3.3.3
            Assert.assertEquals("Normalization should include all descendants at the correct level", 4, output.length);
            Assert.assertStrictlyEquals("Normalization should include grandchild2.1.2", root.getDataChildAt(1).getDataChildAt(0).getDataChildAt(1), output[0]);
            Assert.assertStrictlyEquals("Normalization should include grandchild3.3.1", root.getDataChildAt(2).getDataChildAt(2).getDataChildAt(0), output[1]);
            Assert.assertStrictlyEquals("Normalization should include grandchild3.3.2", root.getDataChildAt(2).getDataChildAt(2).getDataChildAt(1), output[2]);
            Assert.assertStrictlyEquals("Normalization should include grandchild3.3.3", root.getDataChildAt(2).getDataChildAt(2).getDataChildAt(2), output[3]);
        }
    }
}
