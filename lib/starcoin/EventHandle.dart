part of starcoin_types;

class EventHandle {
  int count;
  EventKey key;

  EventHandle(int count, EventKey key) {
    this.count = count;
    this.key = key;
  }

  void serialize(BinarySerializer serializer){
    serializer.serialize_u64(count);
    key.serialize(serializer);
  }

  Uint8List bcsSerialize() {
      var serializer = new BcsSerializer();
      serialize(serializer);
      return serializer.get_bytes();
  }

  static EventHandle deserialize(BinaryDeserializer deserializer){
    var count = deserializer.deserialize_u64();
    var key = EventKey.deserialize(deserializer);
    return new EventHandle(count,key);
  }

  static EventHandle bcsDeserialize(Uint8List input)  {
     var deserializer = new BcsDeserializer(input);
      EventHandle value = deserialize(deserializer);
      if (deserializer.get_buffer_offset() < input.length) {
           throw new Exception("Some input bytes were not read");
      }
      return value;
  }

  @override
  bool operator ==(covariant EventHandle other) {
    if (other == null) return false;

    if (  this.count == other.count  &&
      this.key == other.key  ){
    return true;}
    else return false;
  }

  @override
  int get hashCode {
    int value = 7;
    value = 31 * value + (this.count != null ? this.count.hashCode : 0);
    value = 31 * value + (this.key != null ? this.key.hashCode : 0);
    return value;
  }

  EventHandle.fromJson(dynamic json) :
    count = json['count'] ,
    key = EventKey.fromJson(json['key']) ;

  dynamic toJson() => {
    "count" : count ,
    "key" : key.toJson() ,
  };
}
