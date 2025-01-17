part of starcoin_types;

class BlockMetadata {
  HashValue parent_hash;
  int timestamp;
  AccountAddress author;
  Bytes auth_key_prefix;
  int uncles;
  int number;

  BlockMetadata(HashValue parent_hash, int timestamp, AccountAddress author, Bytes auth_key_prefix, int uncles, int number) {
    this.parent_hash = parent_hash;
    this.timestamp = timestamp;
    this.author = author;
    this.auth_key_prefix = auth_key_prefix;
    this.uncles = uncles;
    this.number = number;
  }

  void serialize(BinarySerializer serializer){
    parent_hash.serialize(serializer);
    serializer.serialize_u64(timestamp);
    author.serialize(serializer);
    serializer.serialize_bytes(auth_key_prefix);
    serializer.serialize_u64(uncles);
    serializer.serialize_u64(number);
  }

  Uint8List bcsSerialize() {
      var serializer = new BcsSerializer();
      serialize(serializer);
      return serializer.get_bytes();
  }

  static BlockMetadata deserialize(BinaryDeserializer deserializer){
    var parentHash = HashValue.deserialize(deserializer);
    var timestamp = deserializer.deserialize_u64();
    var author = AccountAddress.deserialize(deserializer);
    var authKeyPrefix = deserializer.deserialize_bytes();
    var uncles = deserializer.deserialize_u64();
    var number = deserializer.deserialize_u64();
    return new BlockMetadata(parentHash,timestamp,author,authKeyPrefix,uncles,number);
  }

  static BlockMetadata bcsDeserialize(Uint8List input)  {
     var deserializer = new BcsDeserializer(input);
      BlockMetadata value = deserialize(deserializer);
      if (deserializer.get_buffer_offset() < input.length) {
           throw new Exception("Some input bytes were not read");
      }
      return value;
  }

  @override
  bool operator ==(covariant BlockMetadata other) {
    if (other == null) return false;

    if (  this.parent_hash == other.parent_hash  &&
      this.timestamp == other.timestamp  &&
      this.author == other.author  &&
      this.auth_key_prefix == other.auth_key_prefix  &&
      this.uncles == other.uncles  &&
      this.number == other.number  ){
    return true;}
    else return false;
  }

  @override
  int get hashCode {
    int value = 7;
    value = 31 * value + (this.parent_hash != null ? this.parent_hash.hashCode : 0);
    value = 31 * value + (this.timestamp != null ? this.timestamp.hashCode : 0);
    value = 31 * value + (this.author != null ? this.author.hashCode : 0);
    value = 31 * value + (this.auth_key_prefix != null ? this.auth_key_prefix.hashCode : 0);
    value = 31 * value + (this.uncles != null ? this.uncles.hashCode : 0);
    value = 31 * value + (this.number != null ? this.number.hashCode : 0);
    return value;
  }

  BlockMetadata.fromJson(dynamic json) :
    parent_hash = HashValue.fromJson(json['parent_hash']) ,
    timestamp = json['timestamp'] ,
    author = AccountAddress.fromJson(json['author']) ,
    auth_key_prefix = Bytes.fromJson(json['auth_key_prefix']) ,
    uncles = json['uncles'] ,
    number = json['number'] ;

  dynamic toJson() => {
    "parent_hash" : parent_hash.toJson() ,
    "timestamp" : timestamp ,
    "author" : author.toJson() ,
    "auth_key_prefix" : auth_key_prefix.toJson() ,
    "uncles" : uncles ,
    "number" : number ,
  };
}
