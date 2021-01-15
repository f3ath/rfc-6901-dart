import 'package:rfc_6901/src/token/reference_token.dart';

/// Thrown by [ReferenceToken] when it tries to read or modify
/// a value which does not exist in the [document];
class ReferenceFailure implements Exception {
  ReferenceFailure(this.reference, this.document);

  final ReferenceToken reference;

  final Object? document;
}
