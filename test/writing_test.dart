import 'package:rfc_6901/rfc_6901.dart';
import 'package:test/test.dart';

void write(Function() document, value,
    {Map<String, Object?> results = const {},
    Map<String, String> failures = const {}}) {
  group('Writing "$value" to "${document()}"', () {
    results.forEach((pointer, expected) {
      test('At "$pointer" makes "$expected"', () {
        final doc = document();
        expect(JsonPointer(pointer).write(doc, value), equals(expected));
        expect(doc, equals(document()));
      });
    });
    failures.forEach((pointer, expected) {
      test('At "$pointer" fails at "$expected"', () {
        final doc = document();
        expect(
            () => JsonPointer(pointer).write(doc, value),
            throwsA(predicate((e) =>
                e is BadRoute &&
                e.toString() == 'No value found at $expected')));
        expect(doc, equals(document()));
      });
    });
  });
}

void main() {
  write(() => 'foo', 42, results: {'': 42});

  write(() => [], 42, results: {
    '/-': [42]
  }, failures: {
    '/foo': '/foo'
  });

  write(() => {}, 42, results: {
    '/foo': {'foo': 42},
    '/-': {'-': 42},
    '/0': {'0': 42},
    '/01': {'01': 42},
    '/00': {'00': 42},
  });

  write(
      () => {
            'foo': [
              {'bar': 'baz'}
            ]
          },
      42,
      results: {
        '/foo': {'foo': 42},
        '/foo/0': {
          'foo': [42]
        },
        '/foo/0/bar': {
          'foo': [
            {'bar': 42}
          ]
        },
        '/foo/-/zzz': {
          'foo': [
            {'bar': 'baz'},
            {'zzz': 42}
          ]
        },
        '/foo/-/a/b/c': {
          'foo': [
            {'bar': 'baz'},
            {
              'a': {
                'b': {'c': 42}
              }
            }
          ]
        },
      });

  write(() => {}, 42, results: {
    '/a/-/0/b': {
      'a': [
        {
          '0': {'b': 42}
        }
      ]
    }
  });
}
