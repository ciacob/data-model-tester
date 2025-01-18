package tests {
    import flexunit.framework.Assert;
    import ro.ciacob.desktop.data.DataElement;
    import flash.utils.ByteArray;

    public class Data_Element_Serialization_Tests {

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

        // Test 1: Serialization
        [Test]
        public function test__serialization():void {
            // Populate the DataElement with metadata, content, and children
            element.setMetadata("metaKey", "metaValue");
            element.setContent("contentKey", "contentValue");

            var child:DataElement = new DataElement();
            child.setMetadata("childMetaKey", "childMetaValue");
            element.addDataChild(child);

            // Serialize the DataElement
            var byteArray:ByteArray = element.toSerialized();

            // Verify that the serialized ByteArray is not null and has content
            Assert.assertNotNull("Serialized ByteArray should not be null", byteArray);
            Assert.assertTrue("Serialized ByteArray should have data", byteArray.length > 0);
        }

        // Test 2: Deserialization
        [Test]
        public function test__deserialization():void {
            // Populate the DataElement with metadata, content, and children
            element.setMetadata("metaKey", "metaValue");
            element.setContent("contentKey", "contentValue");

            var child:DataElement = new DataElement();
            child.setMetadata("childMetaKey", "childMetaValue");
            element.addDataChild(child);

            // Serialize the DataElement
            var byteArray:ByteArray = element.toSerialized();

            // Deserialize the ByteArray back into a DataElement
            var deserializedElement:DataElement = DataElement.fromSerialized(byteArray) as DataElement;

            // Verify that the deserialized object matches the original
            Assert.assertNotNull("Deserialized DataElement should not be null", deserializedElement);

            // Verify metadata
            Assert.assertEquals(
                "Deserialized element's metadata should match the original",
                "metaValue",
                deserializedElement.getMetadata("metaKey")
            );

            // Verify content
            Assert.assertEquals(
                "Deserialized element's content should match the original",
                "contentValue",
                deserializedElement.getContent("contentKey")
            );

            // Verify children
            Assert.assertEquals(
                "Deserialized element should have the same number of children as the original",
                1,
                deserializedElement.numDataChildren
            );

            var deserializedChild:DataElement = deserializedElement.getDataChildAt(0);
            Assert.assertNotNull("Deserialized child should not be null", deserializedChild);
            Assert.assertEquals(
                "Deserialized child's metadata should match the original",
                "childMetaValue",
                deserializedChild.getMetadata("childMetaKey")
            );
        }
    }
}
