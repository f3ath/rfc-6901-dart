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
  ].forEach((expression) {
    final pointer = JsonPointer(expression);
    print('Pointer "$pointer" reads ${pointer.read(document)}');
  });

  [
    '/foo/0/bar', // {foo: [{bar: banana}]}
    '/foo/-', // {foo: [{bar: 42}, banana]}
    '/a/b/-/c/d', // {foo: [{bar: 42}], a: {b: [{c: {d: banana}}]}}
  ].forEach((expression) {
    final pointer = JsonPointer(expression);
    final d = pointer.write(document, 'banana');
    print('Add a banana at "$pointer": $d');
  });
}
