import 'package:rfc_6901/src/producer.dart';
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
  void write(document, newValue) {
    if (document is Map) {
      document[token] = newValue;
    } else {
      throw ReferenceFailure(this, document);
    }
  }

  @override
  String toString() => asString;

  @override
  Object createEmptyDocument() => {};

  @override
  Object? readOrCreate(Object? document, Producer producer) {
    if (document is Map) {
      if (document.containsKey(token)) return document[token];
      final value = producer();
      document[token] = value;
      return value;
    }
    throw ReferenceFailure(this, document);
  }
}
