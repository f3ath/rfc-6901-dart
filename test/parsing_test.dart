import 'package:rfc_6901/rfc_6901.dart';
import 'package:test/test.dart';

void main() {
  group('Invalid expressions', () {
    for (var entry in <String, String>{
      'a': 'Invalid JSON Pointer "a". Expression MUST start with "/".',
      '~':
          'Invalid JSON Pointer "~". Expression MUST start with "/". Tilda("~") MUST be followed by "0" or "1".',
      '/~':
          'Invalid JSON Pointer "/~". Tilda("~") MUST be followed by "0" or "1".',
      '/~3':
          'Invalid JSON Pointer "/~3". Tilda("~") MUST be followed by "0" or "1".',
      '/~~':
          'Invalid JSON Pointer "/~~". Tilda("~") MUST be followed by "0" or "1".',
      '/foo~~':
          'Invalid JSON Pointer "/foo~~". Tilda("~") MUST be followed by "0" or "1".',
      '/~a~0':
          'Invalid JSON Pointer "/~a~0". Tilda("~") MUST be followed by "0" or "1".',
      '/~~0':
          'Invalid JSON Pointer "/~~0". Tilda("~") MUST be followed by "0" or "1".',
    }.entries) {
      final expression = entry.key;
      final message = entry.value;
      test(expression, () {
        expect(
            () => JsonPointer(expression),
            throwsA(predicate(
                (e) => e is FormatException && e.message == message)));
      });
    }
  });
}
