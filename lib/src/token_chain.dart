import 'package:rfc_6901/src/bad_route.dart';
import 'package:rfc_6901/src/json_pointer.dart';
import 'package:rfc_6901/src/token/reference_failure.dart';
import 'package:rfc_6901/src/token/reference_token.dart';

class TokenChain implements JsonPointer {
  @override
  Object? read(Object? document, {Object? Function()? orElse}) => document;

  @override
  String toString() => '';

  @override
  Object? write(Object? document, Object? newValue) => newValue;

  @override
  Object? add(Object? document, Object? newValue) => newValue;

  @override
  Object? remove(doc) => null;

  @override
  JsonPointer appendToken(String token) => ChainElement(ReferenceToken(token), this);
}

class ChainElement extends TokenChain {
  ChainElement(this.token, this.parent);

  /// The rightmost reference token in the pointer
  final ReferenceToken token;

  final TokenChain parent;

  @override
  Object? read(Object? document, {Object? Function()? orElse}) {
    final node = parent.read(document, orElse: orElse);
    try {
      return token.read(node);
    } on ReferenceFailure {
      if (orElse != null) return orElse();
      throw BadRoute(this);
    }
  }

  @override
  String toString() => '$parent$token';

  @override
  Object? write(Object? document, Object? newValue) {
    final node = parent.read(document, orElse: token.createEmptyDocument);
    try {
      return parent.write(document, token.write(node, newValue));
    } on ReferenceFailure {
      throw BadRoute(this);
    }
  }

  @override
  Object? add(Object? document, Object? newValue) {
    final node = parent.read(document);
    try {
      return parent.write(document, token.add(node, newValue));
    } on ReferenceFailure {
      throw BadRoute(this);
    }
  }

  @override
  Object? remove(Object? document) {
    final node = parent.read(document);
    try {
      return parent.write(document, token.remove(node));
    } on ReferenceFailure {
      throw BadRoute(this);
    }
  }
}
