import 'dart:convert';

import 'package:rfc_6901/rfc_6901.dart';
import 'package:test/test.dart';

void main() {
  test('JSON encoding', () {
    expect(jsonEncode(JsonPointer('/a/b/c')), '"/a/b/c"');
  });
}
