part of starcoin_types;

class ChainId {
  int value;

  ChainId(int value) {
    this.value = value;
  }

  void serialize(BinarySerializer serializer){
    serializer.serialize_u8(value);
  }

  Uint8List bcsSerialize() {
      var serializer = new BcsSerializer();
      serialize(serializer);
      return serializer.get_bytes();
  }

  static ChainId deserialize(BinaryDeserializer deserializer){
    var value = deserializer.deserialize_u8();
    return new ChainId(value);
  }

  static ChainId bcsDeserialize(Uint8List input)  {
     var deserializer = new BcsDeserializer(input);
      ChainId value = deserialize(deserializer);
      if (deserializer.get_buffer_offset() < input.length) {
           throw new Exception("Some input bytes were not read");
      }
      return value;
  }

  @override
  bool operator ==(covariant ChainId other) {
    if (other == null) return false;

    if (  this.value == other.value  ){
    return true;}
    else return false;
  }

  @override
  int get hashCode {
    int value = 7;
    value = 31 * value + (this.value != null ? this.value.hashCode : 0);
    return value;
  }

  ChainId.fromJson(dynamic json) :
    value = json ;

  dynamic toJson() => value;
}
