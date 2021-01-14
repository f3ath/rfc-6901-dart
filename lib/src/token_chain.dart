import 'package:rfc_6901/src/bad_route.dart';
import 'package:rfc_6901/src/json_pointer.dart';
import 'package:rfc_6901/src/producer.dart';
import 'package:rfc_6901/src/token/reference_failure.dart';
import 'package:rfc_6901/src/token/reference_token.dart';

class TokenChain implements JsonPointer {
  TokenChain(this.token, {TokenChain? parent})
      : parent = parent == null ? EmptyParent() : NonEmptyParent(parent);

  /// The rightmost reference token in the pointer
  final ReferenceToken token;

  /// The rest of the chain except the last token.
  final ParentChain parent;

  @override
  Object? read(Object? document) {
    final node = parent.read(document);
    try {
      return token.read(node);
    } on ReferenceFailure {
      throw BadRoute(this);
    }
  }

  @override
  void write(Object? document, Object? newValue) {
    final node = parent.readOrCreate(document, token.createEmptyDocument);
    try {
      token.write(node, newValue);
    } on ReferenceFailure {
      throw BadRoute(this);
    }
  }

  @override
  JsonPointer append(String token) =>
      TokenChain(ReferenceToken(token), parent: this);

  @override
  JsonPointer appendAll(Iterable<String> tokens) =>
      tokens.fold(this, (pointer, token) => pointer.append(token));

  @override
  String toString() => '$parent$token';

  Object? readOrCreate(Object? document, Producer producer) {
    final node = parent.readOrCreate(document, token.createEmptyDocument);
    try {
      return token.readOrCreate(node, producer);
    } on ReferenceFailure {
      throw BadRoute(this);
    }
  }
}

abstract class ParentChain {
  Object? read(Object? document);

  Object? readOrCreate(Object? document, Producer producer);
}

class NonEmptyParent implements ParentChain {
  NonEmptyParent(this.chain);

  final TokenChain chain;

  @override
  Object? read(Object? document) => chain.read(document);

  @override
  Object? readOrCreate(Object? document, producer) =>
      chain.readOrCreate(document, producer);

  @override
  String toString() => chain.toString();
}

class EmptyParent implements ParentChain {
  @override
  Object? read(Object? document) => document;

  @override
  Object? readOrCreate(Object? document, producer) => document;

  @override
  String toString() => '';
}
