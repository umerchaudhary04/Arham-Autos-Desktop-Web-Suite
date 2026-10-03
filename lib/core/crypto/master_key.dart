import 'dart:math';

class MasterKey {
  static final _random = Random.secure();
  static const _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  static String generate() {
    final buffer = StringBuffer();
    for (int i = 0; i < 16; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write('-');
      }
      buffer.write(_alphabet[_random.nextInt(_alphabet.length)]);
    }
    return buffer.toString();
  }

  static String normalize(String key) {
    return key.toUpperCase().replaceAll('-', '').replaceAll(' ', '');
  }
}
