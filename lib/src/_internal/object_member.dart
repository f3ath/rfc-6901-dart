import 'package:rfc_6901/src/_internal/reference.dart';
import 'package:rfc_6901/src/_internal/reference_failure.dart';

/// An object member
class ObjectMember implements Reference {
  const ObjectMember(this.token);

  final String token;

  @override
  Object? read(document) {
    if (document is Map && document.containsKey(token)) {
      return document[token];
    }
    throw ReferenceFailure(this, document);
  }

  @override
  Object? write(Object? document, Object? newValue) {
    if (document is Map) {
      return {...document, token: newValue};
    }
    throw ReferenceFailure(this, document);
  }

  @override
  Object? add(Object? document, Object? newValue) => write(document, newValue);

  @override
  Object? remove(Object? document) {
    if (document is Map && document.containsKey(token)) {
      return {...document}..remove(token);
    }
    throw ReferenceFailure(this, document);
  }

  @override
  String toString() => Reference.escape(token);

  @override
  Object emptyDocument() => {};
}
