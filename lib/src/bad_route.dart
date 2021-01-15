import 'package:rfc_6901/src/json_pointer.dart';

class BadRoute implements Exception {
  BadRoute(this.pointer);

  final JsonPointer pointer;

  @override
  String toString() => 'No value found at $pointer';
}
