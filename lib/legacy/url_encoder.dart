import 'dart:convert';

String utf8Base64UrlEncode(String inputStr) {
  // Encode the string as UTF-8 bytes
  List<int> utf8Bytes = utf8.encode(inputStr);

  // Encode to base64 URL-safe format and remove trailing '='
  String base64UrlStr = base64Url.encode(utf8Bytes);
  return base64UrlStr.replaceAll('=', '');
}

String utf8Base64UrlDecode(String encodedStr) {
  // Add padding '=' if needed
  String padding = '=' * ((4 - encodedStr.length % 4) % 4);
  String base64UrlStr = encodedStr + padding;

  // Decode from base64 and then UTF-8
  List<int> decodedBytes = base64Url.decode(base64UrlStr);
  return utf8.decode(decodedBytes);
}
