part of starcoin_types;

class ContractEventV0 {
  EventKey key;
  int sequence_number;
  TypeTag type_tag;
  Bytes event_data;

  ContractEventV0(EventKey key, int sequence_number, TypeTag type_tag, Bytes event_data) {
    this.key = key;
    this.sequence_number = sequence_number;
    this.type_tag = type_tag;
    this.event_data = event_data;
  }

  void serialize(BinarySerializer serializer){
    key.serialize(serializer);
    serializer.serialize_u64(sequence_number);
    type_tag.serialize(serializer);
    serializer.serialize_bytes(event_data);
  }

  Uint8List bcsSerialize() {
      var serializer = new BcsSerializer();
      serialize(serializer);
      return serializer.get_bytes();
  }

  static ContractEventV0 deserialize(BinaryDeserializer deserializer){
    var key = EventKey.deserialize(deserializer);
    var sequenceNumber = deserializer.deserialize_u64();
    var typeTag = TypeTag.deserialize(deserializer);
    var eventData = deserializer.deserialize_bytes();
    return new ContractEventV0(key,sequenceNumber,typeTag,eventData);
  }

  static ContractEventV0 bcsDeserialize(Uint8List input)  {
     var deserializer = new BcsDeserializer(input);
      ContractEventV0 value = deserialize(deserializer);
      if (deserializer.get_buffer_offset() < input.length) {
           throw new Exception("Some input bytes were not read");
      }
      return value;
  }

  @override
  bool operator ==(covariant ContractEventV0 other) {
    if (other == null) return false;

    if (  this.key == other.key  &&
      this.sequence_number == other.sequence_number  &&
      this.type_tag == other.type_tag  &&
      this.event_data == other.event_data  ){
    return true;}
    else return false;
  }

  @override
  int get hashCode {
    int value = 7;
    value = 31 * value + (this.key != null ? this.key.hashCode : 0);
    value = 31 * value + (this.sequence_number != null ? this.sequence_number.hashCode : 0);
    value = 31 * value + (this.type_tag != null ? this.type_tag.hashCode : 0);
    value = 31 * value + (this.event_data != null ? this.event_data.hashCode : 0);
    return value;
  }

  ContractEventV0.fromJson(dynamic json) :
    key = EventKey.fromJson(json['key']) ,
    sequence_number = json['sequence_number'] ,
    type_tag = TypeTag.fromJson(json['type_tag']) ,
    event_data = Bytes.fromJson(json['event_data']) ;

  dynamic toJson() => {
    "key" : key.toJson() ,
    "sequence_number" : sequence_number ,
    "type_tag" : type_tag.toJson() ,
    "event_data" : event_data.toJson() ,
  };
}
