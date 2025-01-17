part of starcoin_types;

class StructTag {
  AccountAddress address;
  Identifier module;
  Identifier name;
  List<TypeTag> type_params;

  StructTag(AccountAddress address, Identifier module, Identifier name, List<TypeTag> type_params) {
    this.address = address;
    this.module = module;
    this.name = name;
    this.type_params = type_params;
  }

  void serialize(BinarySerializer serializer){
    address.serialize(serializer);
    module.serialize(serializer);
    name.serialize(serializer);
    TraitHelpers.serialize_vector_TypeTag(type_params, serializer);
  }

  Uint8List bcsSerialize() {
      var serializer = new BcsSerializer();
      serialize(serializer);
      return serializer.get_bytes();
  }

  static StructTag deserialize(BinaryDeserializer deserializer){
    var address = AccountAddress.deserialize(deserializer);
    var module = Identifier.deserialize(deserializer);
    var name = Identifier.deserialize(deserializer);
    var typeParams = TraitHelpers.deserialize_vector_TypeTag(deserializer);
    return new StructTag(address,module,name,typeParams);
  }

  static StructTag bcsDeserialize(Uint8List input)  {
     var deserializer = new BcsDeserializer(input);
      StructTag value = deserialize(deserializer);
      if (deserializer.get_buffer_offset() < input.length) {
           throw new Exception("Some input bytes were not read");
      }
      return value;
  }

  @override
  bool operator ==(covariant StructTag other) {
    if (other == null) return false;

    if (  this.address == other.address  &&
      this.module == other.module  &&
      this.name == other.name  &&
      isListsEqual(this.type_params , other.type_params)  ){
    return true;}
    else return false;
  }

  @override
  int get hashCode {
    int value = 7;
    value = 31 * value + (this.address != null ? this.address.hashCode : 0);
    value = 31 * value + (this.module != null ? this.module.hashCode : 0);
    value = 31 * value + (this.name != null ? this.name.hashCode : 0);
    value = 31 * value + (this.type_params != null ? this.type_params.hashCode : 0);
    return value;
  }

  StructTag.fromJson(dynamic json) :
    address = AccountAddress.fromJson(json['address']) ,
    module = Identifier.fromJson(json['module']) ,
    name = Identifier.fromJson(json['name']) ,
    type_params = List<TypeTag>.from(json['type_params'].map((f) => TypeTag.fromJson(f)).toList()) ;

  dynamic toJson() => {
    "address" : address.toJson() ,
    "module" : module.toJson() ,
    "name" : name.toJson() ,
    'type_params' : type_params.map((f) => f.toJson()).toList(),
  };
}
