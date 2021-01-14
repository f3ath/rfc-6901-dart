import 'package:rfc_6901/json_pointer.dart';
import 'package:test/test.dart';

void main() {
  group('Parsing', () {
    [
      'a',
      '/~',
      '/~3',
      '/~~',
      '/foo~~',
      '/~a~0',
      '/~~0',
    ].forEach((expression) {
      test('Invalid expression: $expression', () {
        expect(() => JsonPointer(expression), throwsFormatException);
      });
    });
  });
}
