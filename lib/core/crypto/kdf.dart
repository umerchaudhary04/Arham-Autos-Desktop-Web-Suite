import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';

class Kdf {
  static const int iterations = 210000;
  static final _random = Random.secure();

  static Future<String> hashPassword(String password) async {
    final salt = List<int>.generate(16, (i) => _random.nextInt(256));
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iterations,
      bits: 256,
    );
    final secretKey = SecretKey(utf8.encode(password));
    final result = await pbkdf2.deriveKey(secretKey: secretKey, nonce: salt);
    final hash = await result.extractBytes();
    
    final saltB64 = base64Encode(salt);
    final hashB64 = base64Encode(hash);
    return 'pbkdf2-sha256\$$iterations\$$saltB64\$$hashB64';
  }

  static Future<bool> verifyPassword(String password, String phcString) async {
    final parts = phcString.split('\$');
    if (parts.length != 4) return false;
    final storedIters = int.parse(parts[1]);
    final salt = base64Decode(parts[2]);
    final storedHash = parts[3];

    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: storedIters,
      bits: 256,
    );
    final secretKey = SecretKey(utf8.encode(password));
    final result = await pbkdf2.deriveKey(secretKey: secretKey, nonce: salt);
    final hash = await result.extractBytes();
    
    return base64Encode(hash) == storedHash;
  }
}
