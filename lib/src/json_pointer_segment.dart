import 'package:rfc_6901/src/_internal/encoding_mixin.dart';
import 'package:rfc_6901/src/_internal/reference.dart';
import 'package:rfc_6901/src/_internal/reference_failure.dart';
import 'package:rfc_6901/src/bad_route.dart';
import 'package:rfc_6901/src/json_pointer.dart';

/// JSON Pointer containing at least one reference
class JsonPointerSegment with Encoding implements JsonPointer {
  JsonPointerSegment(String token, this.parent) : _reference = Reference(token);

  @override
  final JsonPointer parent;

  final Reference _reference;

  @override
  Object? add(Object? document, Object? newValue) {
    final node = parent.read(document);
    try {
      return parent.write(document, _reference.add(node, newValue));
    } on ReferenceFailure {
      throw BadRoute(this, document);
    }
  }

  @override
  Object? read(Object? document, {Object? Function()? orElse}) {
    final node = parent.read(document, orElse: orElse);
    try {
      return _reference.read(node);
    } on ReferenceFailure {
      if (orElse != null) return orElse();
      throw BadRoute(this, document);
    }
  }

  @override
  Object? remove(Object? document) {
    final node = parent.read(document);
    try {
      return parent.write(document, _reference.remove(node));
    } on ReferenceFailure {
      throw BadRoute(this, document);
    }
  }

  @override
  Object? write(Object? document, Object? newValue) {
    final node = parent.read(document, orElse: _reference.emptyDocument);
    try {
      return parent.write(document, _reference.write(node, newValue));
    } on ReferenceFailure {
      throw BadRoute(this, document);
    }
  }

  /// hashCode of the given path determines equality
  @override
  int get hashCode => toString().hashCode;

  /// Compares the pointer paths for equality
  @override
  bool operator ==(otherPointer) =>
      otherPointer is JsonPointer && toString() == otherPointer.toString();

  @override
  String toString() => '$parent/$_reference';
}
