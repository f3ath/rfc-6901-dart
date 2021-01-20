import 'dart:convert';

import 'package:rfc_6901/rfc_6901.dart';
import 'package:test/test.dart';

void read(document,
    {Map<String, Object?> results = const {},
    Map<String, String> failures = const {}}) {
  group('Reading document "$document"', () {
    results.forEach((pointer, expected) {
      test('"$pointer" returns "$expected"', () {
        expect(JsonPointer(pointer).read(document), equals(expected));
      });
    });
    failures.forEach((pointer, expected) {
      test('"$pointer" fails at "$expected"', () {
        expect(
            () => JsonPointer(pointer).read(document),
            throwsA(predicate((e) =>
                e is BadRoute &&
                e.toString() == 'No value found at $expected')));
      });
    });
  });
}

void main() {
  group('Reading', () {
    final document = jsonDecode('{"foo": [{"bar": 42}]}');

    read(document,
        results: {'': document, '/foo/0/bar': 42},
        failures: {'/foo/-': '/foo/-', '/foo/01/bar': '/foo/01'});

    read([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
        results: {'/10': 10, '/0': 0, '/1': 1, '/9': 9},
        failures: {'/01': '/01', '/00': '/00', '/-1': '/-1'});

    read({'-': 'foo'}, results: {'/-': 'foo'});

    read({'1': 'foo'}, results: {'/1': 'foo'});
    read({'': 'foo'}, results: {'/': 'foo'});
    read({r'\': 'foo'}, results: {r'/\': 'foo'});
    read({r'a\t': 'foo'}, results: {r'/a\t': 'foo'});
    read({r'/': 'foo'}, results: {'/~1': 'foo'});
    read({r'\u0123': 'foo'}, results: {r'/\u0123': 'foo'});
    read({'"foo"': 'foo'}, results: {'/"foo"': 'foo'});
    read({'~bar': 'foo'}, results: {'/~0bar': 'foo'});
    read({'/~/': 'foo'}, results: {'/~1~0~1': 'foo'});
    read({r'\~': 'foo'}, results: {r'/\~0': 'foo'});
    read({r"\'~": 'foo'}, results: {r"/\'~0": 'foo'});
    read({' ': 'foo'}, results: {'/ ': 'foo'});
    read({'\t': 'foo'}, results: {'/\t': 'foo'});
    read({'-2': 'foo'}, results: {'/-2': 'foo'});
    read({'0': 'foo'}, results: {'/0': 'foo'});
    read({'00': 'foo'}, results: {'/00': 'foo'});
    read({'01': 'foo'}, results: {'/01': 'foo'});

    read({'foo': null}, results: {'/foo': null});
  });
}
