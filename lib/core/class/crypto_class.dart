import 'package:encrypt/encrypt.dart';

class EncryptionService {
  final key = Key.fromUtf8('put32charactershereeeeeeeeeeeee!'); //32 chars
  final iv = IV.fromUtf8('put16characters!'); //16 chars

  String encryptText(String text) {
    final e = Encrypter(AES(key, mode: AESMode.cbc));
    final encryptedData = e.encrypt(text, iv: iv);
    return encryptedData.base64;
  }

  String decryptText(String encryptedText) {
    try {
      final e = Encrypter(AES(key, mode: AESMode.cbc));
      final decryptedData = e.decrypt(Encrypted.fromBase64(encryptedText), iv: iv);
      return decryptedData;
    } catch (e) {
    
      return 'Decryption failed';
    }
  }
}