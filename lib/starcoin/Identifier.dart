part of starcoin_types;

class Identifier {
  String value;

  Identifier(String value) {
    this.value = value;
  }

  void serialize(BinarySerializer serializer){
    serializer.serialize_str(value);
  }

  Uint8List bcsSerialize() {
      var serializer = new BcsSerializer();
      serialize(serializer);
      return serializer.get_bytes();
  }

  static Identifier deserialize(BinaryDeserializer deserializer){
    var value = deserializer.deserialize_str();
    return new Identifier(value);
  }

  static Identifier bcsDeserialize(Uint8List input)  {
     var deserializer = new BcsDeserializer(input);
      Identifier value = deserialize(deserializer);
      if (deserializer.get_buffer_offset() < input.length) {
           throw new Exception("Some input bytes were not read");
      }
      return value;
  }

  @override
  bool operator ==(covariant Identifier other) {
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

  Identifier.fromJson(dynamic json) :
    value = json ;

  dynamic toJson() => value;
}
