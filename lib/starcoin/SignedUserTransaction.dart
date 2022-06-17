part of starcoin_types;

class SignedUserTransaction {
  RawTransaction raw_txn;
  TransactionAuthenticator authenticator;

  SignedUserTransaction(RawTransaction raw_txn, TransactionAuthenticator authenticator) {
    this.raw_txn = raw_txn;
    this.authenticator = authenticator;
  }

  void serialize(BinarySerializer serializer){
    raw_txn.serialize(serializer);
    authenticator.serialize(serializer);
  }

  Uint8List bcsSerialize() {
      var serializer = new BcsSerializer();
      serialize(serializer);
      return serializer.get_bytes();
  }

  static SignedUserTransaction deserialize(BinaryDeserializer deserializer){
    var rawTxn = RawTransaction.deserialize(deserializer);
    var authenticator = TransactionAuthenticator.deserialize(deserializer);
    return new SignedUserTransaction(rawTxn,authenticator);
  }

  static SignedUserTransaction bcsDeserialize(Uint8List input)  {
     var deserializer = new BcsDeserializer(input);
      SignedUserTransaction value = deserialize(deserializer);
      if (deserializer.get_buffer_offset() < input.length) {
           throw new Exception("Some input bytes were not read");
      }
      return value;
  }

  @override
  bool operator ==(covariant SignedUserTransaction other) {
    if (other == null) return false;

    if (  this.raw_txn == other.raw_txn  &&
      this.authenticator == other.authenticator  ){
    return true;}
    else return false;
  }

  @override
  int get hashCode {
    int value = 7;
    value = 31 * value + (this.raw_txn != null ? this.raw_txn.hashCode : 0);
    value = 31 * value + (this.authenticator != null ? this.authenticator.hashCode : 0);
    return value;
  }

  SignedUserTransaction.fromJson(dynamic json) :
    raw_txn = RawTransaction.fromJson(json['raw_txn']) ,
    authenticator = TransactionAuthenticator.fromJson(json['authenticator']) ;

  dynamic toJson() => {
    "raw_txn" : raw_txn.toJson() ,
    "authenticator" : authenticator.toJson() ,
  };
}
