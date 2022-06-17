part of starcoin_types;

class ChangeSet {
  WriteSet write_set;
  List<ContractEvent> events;

  ChangeSet(WriteSet write_set, List<ContractEvent> events) {
    this.write_set = write_set;
    this.events = events;
  }

  void serialize(BinarySerializer serializer){
    write_set.serialize(serializer);
    TraitHelpers.serialize_vector_ContractEvent(events, serializer);
  }

  Uint8List bcsSerialize() {
      var serializer = new BcsSerializer();
      serialize(serializer);
      return serializer.get_bytes();
  }

  static ChangeSet deserialize(BinaryDeserializer deserializer){
    var writeSet = WriteSet.deserialize(deserializer);
    var events = TraitHelpers.deserialize_vector_ContractEvent(deserializer);
    return new ChangeSet(writeSet,events);
  }

  static ChangeSet bcsDeserialize(Uint8List input)  {
     var deserializer = new BcsDeserializer(input);
      ChangeSet value = deserialize(deserializer);
      if (deserializer.get_buffer_offset() < input.length) {
           throw new Exception("Some input bytes were not read");
      }
      return value;
  }

  @override
  bool operator ==(covariant ChangeSet other) {
    if (other == null) return false;

    if (  this.write_set == other.write_set  &&
      isListsEqual(this.events , other.events)  ){
    return true;}
    else return false;
  }

  @override
  int get hashCode {
    int value = 7;
    value = 31 * value + (this.write_set != null ? this.write_set.hashCode : 0);
    value = 31 * value + (this.events != null ? this.events.hashCode : 0);
    return value;
  }

  ChangeSet.fromJson(dynamic json) :
    write_set = WriteSet.fromJson(json['write_set']) ,
    events = List<ContractEvent>.from(json['events'].map((f) => ContractEvent.fromJson(f)).toList()) ;

  dynamic toJson() => {
    "write_set" : write_set.toJson() ,
    'events' : events.map((f) => f.toJson()).toList(),
  };
}
