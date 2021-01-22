# [RFC 6901] JSON Pointer
JSON Pointer ([RFC 6901]) implementation in Dart.

Features:
- Reads and writes values
- Fully implements the standard, including the `-` character
- Can build an entire path, e.g. `/foo/bar/-/baz`
- No external dependencies
- 100% test coverage

## Constructing pointers
A JSON Pointer object can be parsed from a string expression. 
The expression MUST be a valid non-empty JSON Pointer expression with "/" and "~" escaped.
```dart
final pointer = JsonPointer('/foo/0/bar'); // a valid non-empty pointer
final alsoPointer = JsonPointer('/foo/-'); // a valid non-empty pointer with a special "-" reference

JsonPointer('oops'); // throws a FormatException: expression doesn't start with "/"
JsonPointer(''); // throws a FormatException: expression doesn't start with "/" either
JsonPointer('/foo/~'); // throws a FormatException: unescaped "~'
```

It can also be built from individual reference tokens. In such case, it will escape the tokens automatically.
```dart
final pointer = JsonPointer.build(['foo', '0', 'bar/']); // Makes "/foo/0/bar~1"
final longerPointer = pointer.appendToken('-'); // Makes "/foo/0/bar~1/-"
```

## Reading and writing values
The `read()` method returns the referenced value. The `write()` method returns a copy of the document with 
the referenced value replaced by the new value.
```dart
import 'dart:convert';

import 'package:rfc_6901/rfc_6901.dart';

void main() {
  const json = '{"foo": [{"bar": 42}]}';
  final document = jsonDecode(json);
  print('Original document: $document');

  [
    '/foo', // reads the array
    '/foo/0', // reads the first element of the array
    '/foo/0/bar', // reads 42
  ].map((expression) => JsonPointer(expression)).forEach((pointer) {
    print('Pointer "$pointer" reads ${pointer.read(document)}');
  });

  [
    '/foo/0/bar', // {foo: [{bar: banana}]}
    '/foo/-', // {foo: [{bar: 42}, banana]}
    '/a/b/-/c/d', // {foo: [{bar: 42}], a: {b: [{c: {d: banana}}]}}
  ].map((expression) => JsonPointer(expression)).forEach((pointer) {
    final d = pointer.write(document, 'banana');
    print('Add a banana at "$pointer": $d');
  });
}

```

[RFC 6901]: https://tools.ietf.org/html/rfc6901