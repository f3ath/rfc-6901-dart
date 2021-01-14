import 'dart:convert';

import 'package:rfc_6901/json_pointer.dart';
import 'package:test/test.dart';

void main() {
  group('Reading', () {
    final document = jsonDecode('{"foo": [{"bar": 42}]}');

    test('array index', () {
      final doc = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
      expect(JsonPointer('/10').read(doc), 10);
      expect(JsonPointer('/0').read(doc), 0);
      expect(JsonPointer('/1').read(doc), 1);
      expect(JsonPointer('/9').read(doc), 9);
      expect(() => JsonPointer('/01').read(doc),
          throwsA(predicate((e) => e is BadRoute)));
      expect(() => JsonPointer('/00').read(doc),
          throwsA(predicate((e) => e is BadRoute)));
      expect(() => JsonPointer('/-1').read(doc),
          throwsA(predicate((e) => e is BadRoute)));
    });
    test('/foo/0/bar', () {
      expect(JsonPointer('/foo/0/bar').read(document), 42);
    });
    test('/foo/- throws not found', () {
      expect(
          () => JsonPointer('/foo/-').read(document),
          throwsA(predicate(
              (e) => e is BadRoute && e.toString().contains('/foo/-'))));
    });
    test('- works on objects', () {
      expect(JsonPointer('/-').read({'-': 'foo'}), 'foo');
    });
    test('numerical keys work on objects', () {
      expect(JsonPointer('/1').read({'1': 'foo'}), 'foo');
    });
    test('/foo/01/bar throws not found', () {
      expect(
          () => JsonPointer('/foo/01/bar').read(document),
          throwsA(predicate((e) =>
              e is BadRoute &&
              e.toString() == 'No value found at /foo/01')));
    });
    test('special chars', () {
      final doc = {
        '': 0,
        r'\': 1,
        r'a\t': 2,
        '/': 3,
        r'\u0123': 4,
        '"foo"': 5,
        '~bar': 6,
        '/~/': 7,
        r'\~': 8,
        r"\'~": 9,
        ' ': 10,
        '\t': 11,
        '-2': 12,
        '0': 13,
        '00': 14,
        '01': 15,
      };
      expect(JsonPointer('/').read(doc), 0);
      expect(JsonPointer(r'/\').read(doc), 1);
      expect(JsonPointer(r'/a\t').read(doc), 2);
      expect(JsonPointer('/~1').read(doc), 3);
      expect(JsonPointer(r'/\u0123').read(doc), 4);
      expect(JsonPointer('/"foo"').read(doc), 5);
      expect(JsonPointer('/~0bar').read(doc), 6);
      expect(JsonPointer('/~1~0~1').read(doc), 7);
      expect(JsonPointer(r'/\~0').read(doc), 8);
      expect(JsonPointer(r"/\'~0").read(doc), 9);
      expect(JsonPointer('/ ').read(doc), 10);
      expect(JsonPointer('/\t').read(doc), 11);
      expect(JsonPointer('/-2').read(doc), 12);
      expect(JsonPointer('/0').read(doc), 13);
      expect(JsonPointer('/00').read(doc), 14);
      expect(JsonPointer('/01').read(doc), 15);
    });
    test('can read null', () {
      final doc = {'foo': null};
      expect(JsonPointer('/foo').read(doc), null);
    });
  });
}
