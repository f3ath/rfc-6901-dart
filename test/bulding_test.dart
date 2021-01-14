import 'package:rfc_6901/json_pointer.dart';
import 'package:test/test.dart';

void main() {
  group('Building', () {
    test('field', () {
      expect(JsonPointer.build('foo').toString(), '/foo');
    });
    test('/', () {
      expect(JsonPointer.build('/').toString(), '/~1');
    });
    test('~', () {
      expect(JsonPointer.build('~').toString(), '/~0');
    });
    test('/ + ~ +foo + "" + ~0 + 0', () {
      expect(JsonPointer.build('/', ['~', 'foo', '', '~0', '0']).toString(),
          '/~1/~0/foo//~00/0');
    });
  });
}
