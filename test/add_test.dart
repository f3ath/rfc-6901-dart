import 'package:rfc_6901/rfc_6901.dart';
import 'package:test/test.dart';

void add(Function() document, value,
    {Map<String, Object?> results = const {},
    Map<String, String> failures = const {}}) {
  group('Adding "$value" to "${document()}"', () {
    results.forEach((pointer, expected) {
      test('At "$pointer" makes "$expected"', () {
        final doc = document();
        expect(JsonPointer(pointer).add(doc, value), equals(expected));
        expect(doc, equals(document()));
      });
    });
    failures.forEach((pointer, expected) {
      test('At "$pointer" fails at "$expected"', () {
        final doc = document();
        expect(
            () => JsonPointer(pointer).add(doc, value),
            throwsA(predicate((e) =>
                e is BadRoute &&
                e.toString() == 'No value found at $expected')));
        expect(doc, equals(document()));
      });
    });
  });
}

void main() {
  add(() => {}, 42, results: {
    '': 42,
    '/foo': {'foo': 42},
    '/0': {'0': 42},
    '/-': {'-': 42},
  }, failures: {
    '/foo/bar': '/foo',
    '/0/bar': '/0',
    '/-/bar': '/-',
  });
  add(
      () => {
            'foo': {'bar': true}
          },
      42,
      results: {
        '/foo': {'foo': 42},
        '/0': {
          'foo': {'bar': true},
          '0': 42
        },
        '/-': {
          'foo': {'bar': true},
          '-': 42
        },
      });

  add(() => [1, 2, 3], 42, results: {
    '/0': [42, 1, 2, 3],
    '/1': [1, 42, 2, 3],
    '/2': [1, 2, 42, 3],
    '/-': [1, 2, 3, 42],
  }, failures: {
    '/3': '/3',
    '/42': '/42',
    '/-1': '/-1',
    '/foo': '/foo',
    '/00': '/00',
    '/01': '/01',
  });
}
