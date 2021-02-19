import 'package:rfc_6901/src/json_pointer.dart';

/// Exception thrown when a JSON Pointer references a value which does not
/// exist in the document.
class BadRoute implements Exception {
  BadRoute(this.pointer, this.document);

  /// Pointer caused the exception
  final JsonPointer pointer;

  /// The document being processed
  final Object? document;

  @override
  String toString() => 'No value found at $pointer';
}
