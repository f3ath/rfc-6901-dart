import 'package:rfc_6901/rfc_6901.dart';
import 'package:test/test.dart';

void main() {
  group('Building', () {
    <Iterable<String>, String>{
      []: '',
      ['foo']: '/foo',
      ['/']: '/~1',
      ['~']: '/~0',
      ['/', '~', 'foo', '', '~0', '0']: '/~1/~0/foo//~00/0',
    }.forEach((k, v) {
      test('$k => "$v"', () {
        expect(JsonPointer.build(k).toString(), v);
      });
    });
  });
}
