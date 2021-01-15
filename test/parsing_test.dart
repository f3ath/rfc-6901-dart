import 'package:rfc_6901/json_pointer.dart';
import 'package:test/test.dart';

void main() {
  group('Invalid expressions', () {
    [
      'a',
      '/~',
      '/~3',
      '/~~',
      '/foo~~',
      '/~a~0',
      '/~~0',
    ].forEach((expression) {
      test(expression, () {
        expect(() => JsonPointer(expression), throwsFormatException);
      });
    });
  });
}
