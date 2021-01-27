import 'package:rfc_6901/src/_internal/reference.dart';

/// Thrown by [Reference] when it tries to read or modify
/// a value which does not exist in the [document];
class ReferenceFailure implements Exception {
  ReferenceFailure(this.reference, this.document);

  final Reference reference;

  final Object? document;
}
