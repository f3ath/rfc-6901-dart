import 'package:rfc_6901/src/token/reference_failure.dart';
import 'package:rfc_6901/src/token/reference_token.dart';

/// An object member
class ObjectMember implements ReferenceToken {
  ObjectMember(this.token) : asString = '/' + ReferenceToken.escape(token);

  final String token;
  final String asString;

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
  String toString() => asString;

  @override
  Object createEmptyDocument() => {};
}
