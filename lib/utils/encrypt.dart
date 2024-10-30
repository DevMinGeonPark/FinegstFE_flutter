import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:typed_data';

String encryptText(String text) {
  final key =
      encrypt.Key.fromUtf8(dotenv.env['ENCRYPT_SECRET_KEY']!.substring(0, 32));
  final iv = encrypt.IV(Uint8List(16));

  final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

  final encrypted = encrypter.encrypt(text, iv: iv);
  return encrypted.base64;
}
