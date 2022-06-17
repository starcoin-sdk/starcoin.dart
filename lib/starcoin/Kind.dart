part of starcoin_types;

abstract class Kind {
  Kind();

  void serialize(BinarySerializer serializer);

  static Kind deserialize(BinaryDeserializer deserializer) {
    int index = deserializer.deserialize_variant_index();
    switch (index) {
      case 0:
        return KindNewHeadsItem.load(deserializer);
      case 1:
        return KindEventsItem.load(deserializer);
      case 2:
        return KindNewPendingTransactionsItem.load(deserializer);
      case 3:
        return KindNewMintBlockItem.load(deserializer);
      default:
        throw new Exception(
            "Unknown variant index for Kind: " + index.toString());
    }
  }

  Uint8List bcsSerialize() {
    var serializer = new BcsSerializer();
    serialize(serializer);
    return serializer.get_bytes();
  }

  static Kind bcsDeserialize(Uint8List input) {
    var deserializer = new BcsDeserializer(input);
    Kind value = deserialize(deserializer);
    if (deserializer.get_buffer_offset() < input.length) {
      throw new Exception("Some input bytes were not read");
    }
    return value;
  }

  static Kind fromJson(dynamic json) {
    final type = json['type'] as int;
    switch (type) {
      case 0:
        return KindNewHeadsItem.loadJson(json);
      case 1:
        return KindEventsItem.loadJson(json);
      case 2:
        return KindNewPendingTransactionsItem.loadJson(json);
      case 3:
        return KindNewMintBlockItem.loadJson(json);
      default:
        throw new Exception("Unknown type for Kind: " + type.toString());
    }
  }

  dynamic toJson();
}

class KindNewHeadsItem extends Kind {
  KindNewHeadsItem();

  void serialize(BinarySerializer serializer) {
    serializer.serialize_variant_index(0);
  }

  static KindNewHeadsItem load(BinaryDeserializer deserializer) {
    return new KindNewHeadsItem();
  }

  @override
  bool operator ==(covariant KindNewHeadsItem other) {
    if (other == null) return false;
    return true;
  }

  @override
  int get hashCode {
    int value = 7;
    return value;
  }

  KindNewHeadsItem.loadJson(dynamic json);

  dynamic toJson() => {"type": 0, "type_name": "newHeads"};
}

class KindEventsItem extends Kind {
  KindEventsItem();

  void serialize(BinarySerializer serializer) {
    serializer.serialize_variant_index(1);
  }

  static KindEventsItem load(BinaryDeserializer deserializer) {
    return new KindEventsItem();
  }

  @override
  bool operator ==(covariant KindEventsItem other) {
    if (other == null) return false;
    return true;
  }

  @override
  int get hashCode {
    int value = 7;
    return value;
  }

  KindEventsItem.loadJson(dynamic json);

  dynamic toJson() => {"type": 1, "type_name": "events"};
}

class KindNewPendingTransactionsItem extends Kind {
  KindNewPendingTransactionsItem();

  void serialize(BinarySerializer serializer) {
    serializer.serialize_variant_index(2);
  }

  static KindNewPendingTransactionsItem load(BinaryDeserializer deserializer) {
    return new KindNewPendingTransactionsItem();
  }

  @override
  bool operator ==(covariant KindNewPendingTransactionsItem other) {
    if (other == null) return false;
    return true;
  }

  @override
  int get hashCode {
    int value = 7;
    return value;
  }

  KindNewPendingTransactionsItem.loadJson(dynamic json);

  dynamic toJson() => {"type": 2, "type_name": "newPendingTransactions"};
}

class KindNewMintBlockItem extends Kind {
  KindNewMintBlockItem();

  void serialize(BinarySerializer serializer) {
    serializer.serialize_variant_index(3);
  }

  static KindNewMintBlockItem load(BinaryDeserializer deserializer) {
    return new KindNewMintBlockItem();
  }

  @override
  bool operator ==(covariant KindNewMintBlockItem other) {
    if (other == null) return false;
    return true;
  }

  @override
  int get hashCode {
    int value = 7;
    return value;
  }

  KindNewMintBlockItem.loadJson(dynamic json);

  dynamic toJson() => {"type": 3, "type_name": "newMintBlock"};
}
