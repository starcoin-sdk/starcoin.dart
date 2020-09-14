import 'dart:typed_data';
import 'package:ed25519_dart_base/ed25519_dart.dart' as ed25519_dart;
import 'package:starcoin_wallet/wallet/helper.dart';
import 'package:sha3/sha3.dart';

class KeyPair {
  Uint8List _privateKey;

  KeyPair(this._privateKey);

  String getAddress() {
    var address_bytes = Uint8List.fromList(getAddressBytes());
    return Helpers.byteToHex(address_bytes);
  }

  List<int> getAddressBytes() {
    Uint8List publicKey = ed25519_dart.publicKey(_privateKey);
    List<int> key = new List();
    key.addAll(publicKey);
    key.add(0);

    var k = SHA3(256, SHA3_PADDING, 256);
    k.update(key);
    var hash = k.digest();
    return hash.sublist(16, 32);
  }

  Uint8List getPublicKey() {
    return ed25519_dart.publicKey(_privateKey);
  }

  String getPublicKeyHex() {
    return Helpers.byteToHex(getPublicKey());
  }

  Uint8List getPrivateKey() {
    return _privateKey;
  }

  Uint8List sign(Uint8List rawData) {
    //Uint8List salt = Helpers.hexToBytes(HashSaltValues.RawTransactionHashSalt);
    //Uint8List msg = _sha3256.process(Helpers.concat([salt, rawData]));
    //var k = SHA3(256, SHA3_PADDING, 256);
    //k.update(Helpers.concat([salt, rawData]));
    //var hash = k.digest();

    return ed25519_dart.sign(
        rawData, _privateKey, ed25519_dart.publicKey(_privateKey));
  }

  bool verify(Uint8List signature, Uint8List message) {
    return ed25519_dart.verifySignature(signature, message, getPublicKey());
  }
}