import 'package:rfc_6901/src/json_pointer.dart';

/// The empty JSON Pointer
class EmptyJsonPointer implements JsonPointer {
  factory EmptyJsonPointer() => const EmptyJsonPointer._();

  const EmptyJsonPointer._();

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
