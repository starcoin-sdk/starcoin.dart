import 'dart:typed_data';
import 'dart:convert';
import 'package:hex/hex.dart';
import 'package:sha3/sha3.dart';

class Helpers {
  static List<String> hexArray = '0123456789ABCDEF'.split('');

  /// Decode a BigInt from bytes in big-endian encoding.
  static BigInt _decodeBigInt(List<int> bytes) {
    BigInt result = BigInt.from(0);
    for (int i = 0; i < bytes.length; i++) {
      result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
    }
    return result;
  }

  /// Converts a Uint8List to a hex string
  static String byteToHex(Uint8List bytes) {
    return HEX.encode(bytes).toLowerCase();
  }

  /// Converts a List of int to a hex string
  static String listToHex(List<int> list) {
    return byteToHex(Uint8List.fromList(list));
  }

  static BigInt byteToBigInt(Uint8List bytes, {bool le = false}) {
    if (le) {
      bytes = reverse(bytes);
    }
    return _decodeBigInt(bytes);
  }

  /// Converts a hex string to a Uint8List
  static Uint8List hexToBytes(String hex) {
    return Uint8List.fromList(HEX.decode(hex));
  }

  /// Convert a bigint to a byte array
  static Uint8List bigIntToBytes(BigInt bigInt) {
    return hexToBytes(bigInt.toRadixString(16).padLeft(32, '0'));
  }

  static Uint8List bigIntToFixLengthBytes(BigInt bigInt, int length,
      {bool le = false}) {
    String hex = bigInt.toRadixString(16);
    if (hex.length % 2 == 1) {
      hex = '0' + hex;
    }
    Uint8List bytes = hexToBytes(hex);
    if (le) {
      bytes = reverse(bytes);
    }
    if (bytes.length < length) {
      bytes = concat([bytes, new Uint8List(length - bytes.length)]);
    } else {
      bytes = bytes.sublist(0, length);
    }
    return bytes;
  }

  /// Converts a hex string to a binary string
  static String hexToBinary(String hex) {
    return BigInt.parse(hex, radix: 16).toRadixString(2);
  }

  /// Converts a binary string into a hex string
  static String binaryToHex(String binary) {
    return BigInt.parse(binary, radix: 2).toRadixString(16).toLowerCase();
  }

  static Uint8List reverse(Uint8List bytes) {
    Uint8List reversed = Uint8List(bytes.length);
    for (int i = bytes.length; i > 0; i--) {
      reversed[bytes.length - i] = bytes[i - 1];
    }
    return reversed;
  }

  static bool isHexString(String input) {
    List<String> hexChars = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F'
    ];
    for (int i = 0; i < input.length; i++) {
      if (!hexChars.contains(input[i])) {
        return false;
      }
    }
    return true;
  }

  // Convert an integer to a byte array
  static Uint8List intToBytes(int integer, {int length = 4}) {
    Uint8List ret = Uint8List(length);
    for (int i = 0; i < length; i++) {
      ret[i] = integer & 0xff;
      integer = (integer - ret[i]) ~/ 256;
    }
    return Helpers.reverse(ret);
  }

  static Uint8List intToByteArray(int data) {
    Uint8List result = new Uint8List(4);

    result[0] = ((data & 0xFF000000) >> 24);
    result[1] = ((data & 0x00FF0000) >> 16);
    result[2] = ((data & 0x0000FF00) >> 8);
    result[3] = ((data & 0x000000FF) >> 0);

    return result;
  }

  /// Convert string to byte array
  static Uint8List stringToBytesUtf8(String str) {
    return utf8.encode(str);
  }

  /// Convert byte array to string utf-8
  static String bytesToUtf8String(Uint8List bytes) {
    return utf8.decode(bytes);
  }

  /// Concatenates one or more byte arrays
  ///
  /// @param {List<Uint8List>} bytes
  /// @returns {Uint8List}
  static Uint8List concat(List<Uint8List> bytes) {
    String hex = '';
    bytes.forEach((v) {
      hex += Helpers.byteToHex(v);
    });
    return Helpers.hexToBytes(hex);
  }

  static Uint8List publicKeyIntoAddress(Uint8List publicKey) {
    List<int> key = [];
    key.addAll(publicKey);
    key.add(0);

    var k = SHA3(256, SHA3_PADDING, 256);
    k.update(key);
    var hash = k.digest();
    return Uint8List.fromList(hash.sublist(16, 32));
  }

  static String publicKeyIntoAddressHex(String publicKeyHex) {
    final publicKey = hexToBytes(publicKeyHex.replaceFirst("0x", ""));
    return byteToHex(publicKeyIntoAddress(publicKey));
  }
}
