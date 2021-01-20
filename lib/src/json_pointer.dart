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
  factory JsonPointer([String expression = '']) {
    if (expression.isEmpty) return EmptyChain();
    final errors = validate(expression);
    if (errors.isNotEmpty) throw FormatException(errors.join(' '));
    return build(expression.split('/').skip(1).map(ReferenceToken.unescape));
  }

  /// Creates a new JSON Pointer from [tokens].
  static JsonPointer build(Iterable<String> tokens) =>
      tokens.fold(EmptyChain(), (chain, token) => chain.append(token));

  /// Reads the referenced value from the [document].
  /// If no value is referenced, returns the result of [orElse] or throws [BadRoute].
  Object? read(Object? document, {Object? Function()? orElse});

  /// Returns a copy of [document] with the referenced value set to [newValue].
  ///
  /// When a non-existing [Map] key (JSON object member) is referenced,
  /// a new key will be created.
  ///
  /// When a new index in a [List] (JSON Array) is referenced, a new element will
  /// be added to the list.
  ///
  /// All intermediate keys and indexes will be created if possible.
  /// Example:
  /// ```dart
  /// final pointer = JsonPointer('/foo/-/bar');
  /// final doc = pointer.write({}, 42); // {foo:[{bar:42}]}
  ///
  /// // However, the next call will fail with [BadRoute] since it's not possible
  /// // to create a string key in an array
  /// pointer.write([], 42);
  /// ```
  Object? write(Object? document, Object? newValue);

  /// Returns a copy of [document] with the [newValue] added at the referenced location.
  ///
  /// The semantics of this method is meant to be the same as the "add" operation
  /// described in RFC 6902 (JSON Patch).
  ///
  /// - If the target location specifies an array index, the value is inserted at
  /// the specified index shifting existing values.
  /// - If the target location is an key in an object, it will be added or replaced
  /// by the [newValue]
  ///
  /// If any of the intermediate keys and indexes is missing, a [BadRoute] exception
  /// will be thrown.
  ///
  /// If the referenced value
  Object? add(Object? document, Object? newValue);

  /// Returns a copy of [document] with the value at the referenced location removed.
  /// This method returns null if the entire document is referenced
  /// (i.e. JSON Path expression is an empty string).
  ///
  /// The semantics of this method is meant to be the same as the "remove" operation
  /// described in RFC 6902 (JSON Patch).
  ///
  /// The target location must exist, otherwise [BadRoute] will be thrown.
  /// If the target location specifies an array index, the value at the index is removed
  /// and the element above the index are shifted to the left.
  Object? remove(Object? document);

  /// Creates a new JSON Pointer by appending
  /// the unescaped [token] at the end of the expression.
  JsonPointer append(String token);
}
