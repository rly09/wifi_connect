import 'dart:convert';

class Base64Utils {
  /// Decodes a Base64 encoded string to plain text
  static String decode(String encoded) {
    try {
      return utf8.decode(base64.decode(encoded));
    } catch (e) {
      return 'Invalid Password';
    }
  }

  /// Optional: Encode plain text to Base64 (not required for this app)
  static String encode(String plain) {
    return base64.encode(utf8.encode(plain));
  }
}
