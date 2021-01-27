import 'package:rfc_6901/src/json_pointer.dart';

class EmptyPointer implements JsonPointer {
  const EmptyPointer();

  @override
  final parent = null;

  @override
  Object? add(Object? document, Object? newValue) => newValue;

  @override
  Object? read(Object? document, {Object? Function()? orElse}) => document;

  @override
  Object? remove(Object? document) => null;

  @override
  Object? write(Object? document, Object? newValue) => newValue;

  @override
  String toString() => '';
}
