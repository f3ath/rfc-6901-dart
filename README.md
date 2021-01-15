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

It can also be built from individual reference tokens. In such case, it will escape the segments
automatically. Note how `bar/` gets turned into `bar~1`.
```dart
// Produces "/foo/0/bar~1"
final pointerFromSegments = JsonPointer.fromToken('foo', ['0', 'bar/']);

```

## Reading and writing values
```dart
import 'dart:convert';

import 'package:rfc_6901/json_pointer.dart';

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

  // Let's replace 42 with 'hello'
  final bar = JsonPointer('/foo/0/bar');
  bar.write(document, 'hello');
  // The document is {foo: [{bar: hello}]}
  print('Pointer "$bar" can replace 42 with "hello": $document');
  
  // Now let's add a new element to the array
  final newElement = JsonPointer('/foo/-');
  newElement.write(document, 'banana');
  // The document is {foo: [{bar: hello}, banana]}
  print('Pointer "$newElement" adds a banana: $document');

  // Now let's add an entire path to the document
  final longPath = JsonPointer('/a/b/-/c/d');
  longPath.write(document, 'wow');
  // The document is {foo: [{bar: hello}, banana], a: {b: [{c: {d: wow}}]}}
  print('Pointer "$longPath" creates a new path: $document');
}
```

[RFC 6901]: https://tools.ietf.org/html/rfc6901