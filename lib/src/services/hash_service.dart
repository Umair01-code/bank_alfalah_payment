import 'package:encrypt/encrypt.dart' as encrypt;

class HashService {
  final String firstKey;
  final String secondKey;

  HashService({
    required this.firstKey,
    required this.secondKey,
  });

  String generateHash(Map<String, dynamic> data) {
    // Sort keys alphabetically
    final sortedKeys = data.keys.toList()..sort();

    // Create key-value pairs string
    final finalString = sortedKeys.map((key) => '$key=${data[key]}').join('&');

    // Create encryption keys
    final key = encrypt.Key.fromUtf8(firstKey);
    final iv = encrypt.IV.fromUtf8(secondKey);

    // Encrypt using AES
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );

    final encrypted = encrypter.encrypt(finalString, iv: iv);
    return encrypted.base64;
  }
}
