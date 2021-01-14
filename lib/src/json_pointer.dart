import 'package:rfc_6901/src/bad_route.dart';
import 'package:rfc_6901/src/token/reference_token.dart';
import 'package:rfc_6901/src/token_chain.dart';
import 'package:rfc_6901/src/validate.dart';

/// A JSON Pointer [RFC 6901](https://tools.ietf.org/html/rfc6901).
abstract class JsonPointer {
  /// Creates a new JSON Pointer from a non-empty string [expression].
  /// Throws a [FormatException] if the expression is empty or has invalid format.
  /// Example:
  /// ```dart
  /// final pointer = JsonPointer('/foo/bar');
  /// ```
  factory JsonPointer(String expression) {
    final errors = validate(expression);
    if (errors.isNotEmpty) throw FormatException(errors.join(' '));
    final tokens = expression.split('/').skip(1).map(ReferenceToken.unescape);
    return build(tokens.first, tokens.skip(1));
  }

  /// Creates a new JSON Pointer from a [token].
  /// If [moreTokens] are provided, they will be appended at the end.
  static JsonPointer build(String token,
          [Iterable<String> moreTokens = const []]) =>
      TokenChain(ReferenceToken(token)).appendAll(moreTokens);

  /// Reads the referenced value from the [document].
  /// If no value is referenced, throws [BadRoute].
  Object? read(Object? document);

  /// Replaces the referenced value in the [document] with the [newValue].
  /// When a non-existing [Map] key (JSON object member) is referred by the last segment,
  /// a new key will be created and the [newValue] will be assigned to that key.
  /// When a new index in a [List] (JSON Array) is referred by the last segment
  /// (e.g. in `/foo/-`), the [newValue] will be appended to the list.
  /// All intermediate keys and indexes will be created if possible
  /// Example:
  /// ```dart
  /// final doc = {};
  /// final pointer = JsonPointer('/foo/-/bar');
  /// pointer.write(doc, 42);
  /// // doc is now {foo:[{bar:42}]}
  ///
  /// // However, the next call will fail with [BadRoute] since it's not possible
  /// // to create a string key in an array
  /// pointer.write([], 42);
  /// ```
  void write(Object? document, Object? newValue);

  /// Creates a new JSON Pointer by appending
  /// the unescaped [token] at the end of the expression.
  JsonPointer append(String token);

  /// Creates a new JSON Pointer by appending
  /// the unescaped [tokens] at the end of the expression.
  JsonPointer appendAll(Iterable<String> tokens);
}
