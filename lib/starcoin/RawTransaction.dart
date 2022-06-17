part of starcoin_types;

class RawTransaction {
  AccountAddress sender;
  int sequence_number;
  TransactionPayload payload;
  int max_gas_amount;
  int gas_unit_price;
  String gas_token_code;
  int expiration_timestamp_secs;
  ChainId chain_id;

  RawTransaction(AccountAddress sender, int sequence_number, TransactionPayload payload, int max_gas_amount, int gas_unit_price, String gas_token_code, int expiration_timestamp_secs, ChainId chain_id) {
    this.sender = sender;
    this.sequence_number = sequence_number;
    this.payload = payload;
    this.max_gas_amount = max_gas_amount;
    this.gas_unit_price = gas_unit_price;
    this.gas_token_code = gas_token_code;
    this.expiration_timestamp_secs = expiration_timestamp_secs;
    this.chain_id = chain_id;
  }

  void serialize(BinarySerializer serializer){
    sender.serialize(serializer);
    serializer.serialize_u64(sequence_number);
    payload.serialize(serializer);
    serializer.serialize_u64(max_gas_amount);
    serializer.serialize_u64(gas_unit_price);
    serializer.serialize_str(gas_token_code);
    serializer.serialize_u64(expiration_timestamp_secs);
    chain_id.serialize(serializer);
  }

  Uint8List bcsSerialize() {
      var serializer = new BcsSerializer();
      serialize(serializer);
      return serializer.get_bytes();
  }

  static RawTransaction deserialize(BinaryDeserializer deserializer){
    var sender = AccountAddress.deserialize(deserializer);
    var sequenceNumber = deserializer.deserialize_u64();
    var payload = TransactionPayload.deserialize(deserializer);
    var maxGasAmount = deserializer.deserialize_u64();
    var gasUnitPrice = deserializer.deserialize_u64();
    var gasTokenCode = deserializer.deserialize_str();
    var expirationTimestampSecs = deserializer.deserialize_u64();
    var chainId = ChainId.deserialize(deserializer);
    return new RawTransaction(sender,sequenceNumber,payload,maxGasAmount,gasUnitPrice,gasTokenCode,expirationTimestampSecs,chainId);
  }

  static RawTransaction bcsDeserialize(Uint8List input)  {
     var deserializer = new BcsDeserializer(input);
      RawTransaction value = deserialize(deserializer);
      if (deserializer.get_buffer_offset() < input.length) {
           throw new Exception("Some input bytes were not read");
      }
      return value;
  }

  @override
  bool operator ==(covariant RawTransaction other) {
    if (other == null) return false;

    if (  this.sender == other.sender  &&
      this.sequence_number == other.sequence_number  &&
      this.payload == other.payload  &&
      this.max_gas_amount == other.max_gas_amount  &&
      this.gas_unit_price == other.gas_unit_price  &&
      this.gas_token_code == other.gas_token_code  &&
      this.expiration_timestamp_secs == other.expiration_timestamp_secs  &&
      this.chain_id == other.chain_id  ){
    return true;}
    else return false;
  }

  @override
  int get hashCode {
    int value = 7;
    value = 31 * value + (this.sender != null ? this.sender.hashCode : 0);
    value = 31 * value + (this.sequence_number != null ? this.sequence_number.hashCode : 0);
    value = 31 * value + (this.payload != null ? this.payload.hashCode : 0);
    value = 31 * value + (this.max_gas_amount != null ? this.max_gas_amount.hashCode : 0);
    value = 31 * value + (this.gas_unit_price != null ? this.gas_unit_price.hashCode : 0);
    value = 31 * value + (this.gas_token_code != null ? this.gas_token_code.hashCode : 0);
    value = 31 * value + (this.expiration_timestamp_secs != null ? this.expiration_timestamp_secs.hashCode : 0);
    value = 31 * value + (this.chain_id != null ? this.chain_id.hashCode : 0);
    return value;
  }

  RawTransaction.fromJson(dynamic json) :
    sender = AccountAddress.fromJson(json['sender']) ,
    sequence_number = json['sequence_number'] ,
    payload = TransactionPayload.fromJson(json['payload']) ,
    max_gas_amount = json['max_gas_amount'] ,
    gas_unit_price = json['gas_unit_price'] ,
    gas_token_code = json['gas_token_code'] ,
    expiration_timestamp_secs = json['expiration_timestamp_secs'] ,
    chain_id = ChainId.fromJson(json['chain_id']) ;

  dynamic toJson() => {
    "sender" : sender.toJson() ,
    "sequence_number" : sequence_number ,
    "payload" : payload.toJson() ,
    "max_gas_amount" : max_gas_amount ,
    "gas_unit_price" : gas_unit_price ,
    "gas_token_code" : gas_token_code ,
    "expiration_timestamp_secs" : expiration_timestamp_secs ,
    "chain_id" : chain_id.toJson() ,
  };
}
