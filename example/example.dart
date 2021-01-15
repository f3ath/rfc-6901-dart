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
