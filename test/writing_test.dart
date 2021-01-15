import 'dart:convert';

import 'package:rfc_6901/json_pointer.dart';
import 'package:rfc_6901/src/bad_route.dart';
import 'package:test/test.dart';

void main() {
  group('Writing', () {
    Map? document;
    setUp(() {
      document = jsonDecode('{"foo": [{"bar": 42}]}');
    });

    test('write on primitive throws InvalidRoute', () {
      expect(
          () => JsonPointer('/0').write('foo', 'bar'),
          throwsA(predicate(
              (e) => e is BadRoute && e.toString() == 'No value found at /0')));
    });

    test('adding a key fails at arrays', () {
      final doc = {'foo': []};
      expect(() => JsonPointer('/foo/bar').write(doc, 'banana'),
          throwsA((e) => e is BadRoute));
    });

    test('replace existing object member', () {
      final p = JsonPointer('/foo/0/bar');
      p.write(document, 'banana');
      expect(p.read(document), 'banana');
    });

    test('create a new object member', () {
      JsonPointer('/foo/0/baz').write(document, 'banana');
      expect(JsonPointer('/foo/0/baz').read(document), 'banana');
    });

    test('replace existing array index', () {
      JsonPointer('/foo/0').write(document, 'banana');
      expect(JsonPointer('/foo/0').read(document), 'banana');
    });

    test('"-" at the end adds a new array element in array', () {
      JsonPointer('/foo/-').write(document, 'banana');
      expect(JsonPointer('/foo/1').read(document), 'banana');
    });

    test('"-" at the end adds a new member to an object', () {
      JsonPointer('/-/foo').write(document, 'banana');
      expect(JsonPointer('/-/foo').read(document), 'banana');
    });

    test('/foo/- on {}', () {
      final doc = {};
      JsonPointer('/foo/-').write(doc, 'banana');
      expect(JsonPointer('/foo/0').read(doc), 'banana');
    });

    test('/foo/-/bar on {}', () {
      final doc = {};
      JsonPointer('/foo/-/bar').write(doc, 'banana');
      expect(JsonPointer('/foo/0/bar').read(doc), 'banana');
    });

    test('/foo/-/bar/baz on {}', () {
      final doc = {};
      JsonPointer('/foo/-/bar/baz').write(doc, 'banana');
      expect(JsonPointer('/foo/0/bar/baz').read(doc), 'banana');
    });

    test('/0/-/-/bar on [[]]', () {
      final doc = [[]];
      JsonPointer('/0/-/-/bar').write(doc, 'banana');
      expect(JsonPointer('/0/0/0/bar').read(doc), 'banana');
    });

    test('/0/0/0/bar on {}', () {
      final doc = {};
      JsonPointer('/0/0/0/bar').write(doc, 'banana');
      expect(JsonPointer('/0/0/0/bar').read(doc), 'banana');
    });

    test('/foo/-/bar/baz  on "" throws', () {
      final doc = '';
      expect(() => JsonPointer('/foo/-/bar/baz').write(doc, 'banana'),
          throwsA((e) => e is BadRoute));
    });

    test('/foo/3/bar throws (missing index)', () {
      expect(
          () => JsonPointer('/foo/3/bar').write(document, 'banana'),
          throwsA(predicate((e) =>
              e is BadRoute && e.toString() == 'No value found at /foo/3')));
    });
  });
}
