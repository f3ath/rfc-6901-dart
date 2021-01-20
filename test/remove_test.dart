import 'package:rfc_6901/rfc_6901.dart';
import 'package:test/test.dart';

void remove(Function() document,
    {Map<String, Object?> results = const {},
    Map<String, String> failures = const {}}) {
  group('Removing from "${document()}"', () {
    results.forEach((pointer, expected) {
      test('At "$pointer" makes "$expected"', () {
        final doc = document();
        expect(JsonPointer(pointer).remove(doc), equals(expected));
        expect(doc, equals(document()));
      });
    });
    failures.forEach((pointer, expected) {
      test('At "$pointer" fails at "$expected"', () {
        final doc = document();
        expect(
            () => JsonPointer(pointer).remove(document()),
            throwsA(predicate((e) =>
                e is BadRoute &&
                e.toString() == 'No value found at $expected')));
        expect(doc, equals(document()));
      });
    });
  });
}

void main() {
  remove(
      () => {
            'foo': [
              1,
              2,
              {'bar': true}
            ]
          },
      results: {
        '': null,
        '/foo': {},
        '/foo/2/bar': {
          'foo': [1, 2, {}]
        },
        '/foo/2': {
          'foo': [1, 2]
        },
        '/foo/1': {
          'foo': [
            1,
            {'bar': true}
          ]
        },
        '/foo/0': {
          'foo': [
            2,
            {'bar': true}
          ]
        },
      },
      failures: {
        '/zzz': '/zzz',
        '/foo/00': '/foo/00',
        '/foo/-': '/foo/-',
        '/foo/3': '/foo/3',
        '/foo/2/zzz': '/foo/2/zzz',
      });

  remove(() => 42, failures: {'/foo': '/foo', '/0': '/0'});
}
