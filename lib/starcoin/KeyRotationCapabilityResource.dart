part of starcoin_types;

class KeyRotationCapabilityResource {
  AccountAddress account_address;

  KeyRotationCapabilityResource(AccountAddress account_address) {
    this.account_address = account_address;
  }

  void serialize(BinarySerializer serializer){
    account_address.serialize(serializer);
  }

  Uint8List bcsSerialize() {
      var serializer = new BcsSerializer();
      serialize(serializer);
      return serializer.get_bytes();
  }

  static KeyRotationCapabilityResource deserialize(BinaryDeserializer deserializer){
    var accountAddress = AccountAddress.deserialize(deserializer);
    return new KeyRotationCapabilityResource(accountAddress);
  }

  static KeyRotationCapabilityResource bcsDeserialize(Uint8List input)  {
     var deserializer = new BcsDeserializer(input);
      KeyRotationCapabilityResource value = deserialize(deserializer);
      if (deserializer.get_buffer_offset() < input.length) {
           throw new Exception("Some input bytes were not read");
      }
      return value;
  }

  @override
  bool operator ==(covariant KeyRotationCapabilityResource other) {
    if (other == null) return false;

    if (  this.account_address == other.account_address  ){
    return true;}
    else return false;
  }

  @override
  int get hashCode {
    int value = 7;
    value = 31 * value + (this.account_address != null ? this.account_address.hashCode : 0);
    return value;
  }

  KeyRotationCapabilityResource.fromJson(dynamic json) :
    account_address = AccountAddress.fromJson(json['account_address']) ;

  dynamic toJson() => {
    "account_address" : account_address.toJson() ,
  };
}
