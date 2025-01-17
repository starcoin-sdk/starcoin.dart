part of starcoin_types;

abstract class ContractEvent {
  ContractEvent();

  void serialize(BinarySerializer serializer);

  static ContractEvent deserialize(BinaryDeserializer deserializer) {
    int index = deserializer.deserialize_variant_index();
    switch (index) {
      case 0: return ContractEventV0Item.load(deserializer);
      default: throw new Exception("Unknown variant index for ContractEvent: " + index.toString());
    }
  }

  Uint8List bcsSerialize() {
      var serializer = new BcsSerializer();
      serialize(serializer);
      return serializer.get_bytes();
  }

  static ContractEvent bcsDeserialize(Uint8List input)  {
     var deserializer = new BcsDeserializer(input);
      ContractEvent value = deserialize(deserializer);
      if (deserializer.get_buffer_offset() < input.length) {
           throw new Exception("Some input bytes were not read");
      }
      return value;
  }

  static ContractEvent fromJson(dynamic json){
    final type = json['type'] as int;
    switch (type) {
      case 0: return ContractEventV0Item.loadJson(json);
      default: throw new Exception("Unknown type for ContractEvent: " + type.toString());
    }
  }

  dynamic toJson();
}


class ContractEventV0Item extends ContractEvent {
  ContractEventV0 value;

  ContractEventV0Item(ContractEventV0 value) {
    this.value = value;
  }

  void serialize(BinarySerializer serializer){
    serializer.serialize_variant_index(0);
    value.serialize(serializer);
  }

  static ContractEventV0Item load(BinaryDeserializer deserializer){
    var value = ContractEventV0.deserialize(deserializer);
    return new ContractEventV0Item(value);
  }

  @override
  bool operator ==(covariant ContractEventV0Item other) {
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

  ContractEventV0Item.loadJson(dynamic json) :
    value = ContractEventV0.fromJson(json['value']) ;

  dynamic toJson() => {
    "value" : value.toJson() ,
    "type" : 0,
    "type_name" : "V0"
  };
}
