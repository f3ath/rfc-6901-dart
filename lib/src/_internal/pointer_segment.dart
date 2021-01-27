import 'package:rfc_6901/src/_internal/reference.dart';
import 'package:rfc_6901/src/_internal/reference_failure.dart';
import 'package:rfc_6901/src/bad_route.dart';
import 'package:rfc_6901/src/json_pointer.dart';

class PointerSegment implements JsonPointer {
  const PointerSegment(this.reference, this.parent);

  final Reference reference;

  @override
  final JsonPointer parent;

  @override
  Object? add(Object? document, Object? newValue) {
    final node = parent.read(document);
    try {
      return parent.write(document, reference.add(node, newValue));
    } on ReferenceFailure {
      throw BadRoute(this, document);
    }
  }

  @override
  Object? read(Object? document, {Object? Function()? orElse}) {
    final node = parent.read(document, orElse: orElse);
    try {
      return reference.read(node);
    } on ReferenceFailure {
      if (orElse != null) return orElse();
      throw BadRoute(this, document);
    }
  }

  @override
  Object? remove(Object? document) {
    final node = parent.read(document);
    try {
      return parent.write(document, reference.remove(node));
    } on ReferenceFailure {
      throw BadRoute(this, document);
    }
  }

  @override
  Object? write(Object? document, Object? newValue) {
    final node = parent.read(document, orElse: reference.emptyDocument);
    try {
      return parent.write(document, reference.write(node, newValue));
    } on ReferenceFailure {
      throw BadRoute(this, document);
    }
  }

  @override
  String toString() => '$parent/$reference';
}
