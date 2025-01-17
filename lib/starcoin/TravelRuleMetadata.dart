part of starcoin_types;

abstract class TravelRuleMetadata {
  TravelRuleMetadata();

  void serialize(BinarySerializer serializer);

  static TravelRuleMetadata deserialize(BinaryDeserializer deserializer) {
    int index = deserializer.deserialize_variant_index();
    switch (index) {
      case 0: return TravelRuleMetadataTravelRuleMetadataVersion0Item.load(deserializer);
      default: throw new Exception("Unknown variant index for TravelRuleMetadata: " + index.toString());
    }
  }

  Uint8List bcsSerialize() {
      var serializer = new BcsSerializer();
      serialize(serializer);
      return serializer.get_bytes();
  }

  static TravelRuleMetadata bcsDeserialize(Uint8List input)  {
     var deserializer = new BcsDeserializer(input);
      TravelRuleMetadata value = deserialize(deserializer);
      if (deserializer.get_buffer_offset() < input.length) {
           throw new Exception("Some input bytes were not read");
      }
      return value;
  }

  static TravelRuleMetadata fromJson(dynamic json){
    final type = json['type'] as int;
    switch (type) {
      case 0: return TravelRuleMetadataTravelRuleMetadataVersion0Item.loadJson(json);
      default: throw new Exception("Unknown type for TravelRuleMetadata: " + type.toString());
    }
  }

  dynamic toJson();
}


class TravelRuleMetadataTravelRuleMetadataVersion0Item extends TravelRuleMetadata {
  TravelRuleMetadataV0 value;

  TravelRuleMetadataTravelRuleMetadataVersion0Item(TravelRuleMetadataV0 value) {
    this.value = value;
  }

  void serialize(BinarySerializer serializer){
    serializer.serialize_variant_index(0);
    value.serialize(serializer);
  }

  static TravelRuleMetadataTravelRuleMetadataVersion0Item load(BinaryDeserializer deserializer){
    var value = TravelRuleMetadataV0.deserialize(deserializer);
    return new TravelRuleMetadataTravelRuleMetadataVersion0Item(value);
  }

  @override
  bool operator ==(covariant TravelRuleMetadataTravelRuleMetadataVersion0Item other) {
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

  TravelRuleMetadataTravelRuleMetadataVersion0Item.loadJson(dynamic json) :
    value = TravelRuleMetadataV0.fromJson(json['value']) ;

  dynamic toJson() => {
    "value" : value.toJson() ,
    "type" : 0,
    "type_name" : "TravelRuleMetadataVersion0"
  };
}
