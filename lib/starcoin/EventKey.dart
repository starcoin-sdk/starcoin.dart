part of starcoin_types;

class EventKey {
  Bytes value;

  EventKey(Bytes value) {
    this.value = value;
  }

  void serialize(BinarySerializer serializer){
    serializer.serialize_bytes(value);
  }

  Uint8List bcsSerialize() {
      var serializer = new BcsSerializer();
      serialize(serializer);
      return serializer.get_bytes();
  }

  static EventKey deserialize(BinaryDeserializer deserializer){
    var value = deserializer.deserialize_bytes();
    return new EventKey(value);
  }

  static EventKey bcsDeserialize(Uint8List input)  {
     var deserializer = new BcsDeserializer(input);
      EventKey value = deserialize(deserializer);
      if (deserializer.get_buffer_offset() < input.length) {
           throw new Exception("Some input bytes were not read");
      }
      return value;
  }

  @override
  bool operator ==(covariant EventKey other) {
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

  EventKey.fromJson(dynamic json) :
    value = json ;

  dynamic toJson() => value;
}
