import 'package:rfc_6901/src/_internal/empty_pointer.dart';
import 'package:rfc_6901/src/_internal/pointer_segment.dart';
import 'package:rfc_6901/src/_internal/reference.dart';
import 'package:rfc_6901/src/bad_route.dart';

/// A JSON Pointer [RFC 6901](https://tools.ietf.org/html/rfc6901).
abstract class JsonPointer {
  /// Creates a new JSON Pointer from a string [expression].
  /// Throws a [FormatException] if the expression has invalid format.
  /// Example:
  /// ```dart
  /// final pointer = JsonPointer('/foo/bar');
  /// ```
  factory JsonPointer([String expression = '']) {
    if (expression.isEmpty) return _empty;
    validate(expression);
    return build(expression.split('/').skip(1).map(Reference.unescape));
  }

  /// Creates a new JSON Pointer from reference [tokens].
  static JsonPointer build(Iterable<String> tokens) => append(_empty, tokens);

  /// Creates a new JSON Pointer by appending [tokens] to another [pointer].
  static JsonPointer append(JsonPointer pointer, Iterable<String> tokens) =>
      tokens
          .map((token) => Reference(token))
          .fold(pointer, (parent, ref) => PointerSegment(ref, parent));

  /// Throws a [FormatException] if the [expression] is not valid.
  static void validate(String expression) {
    if (expression.isEmpty) return;
    final errors = <String>[];
    if (!expression.startsWith('/')) {
      errors.add('Expression MUST start with "/".');
    }
    if (_danglingTilda.hasMatch(expression)) {
      errors.add('Tilda("~") MUST be followed by "0" or "1".');
    }
    if (errors.isNotEmpty) throw FormatException(errors.join(' '));
  }

  /// Empty JSON Pointer
  static const _empty = EmptyPointer();

  /// Represents a tilda with is not followed by "0" or "1"
  static final _danglingTilda = RegExp(r'~[^01]|~$');

  /// The parent pointer.
  JsonPointer? get parent;

  /// Reads the referenced value from the [document].
  /// If no value is referenced, gets the value from [orElse] or throws [BadRoute].
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
  /// The semantics of this method is the same as the "add" operation
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
  /// The semantics of this method is the same as the "remove" operation
  /// described in RFC 6902 (JSON Patch).
  ///
  /// The target location must exist, otherwise [BadRoute] will be thrown.
  /// If the target location specifies an array index, the value at the index is removed
  /// and the element above the index are shifted to the left.
  Object? remove(Object? document);

  /// Returns the string representation of the pointer.
  @override
  String toString();
}
