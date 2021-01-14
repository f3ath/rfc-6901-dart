import 'package:rfc_6901/src/token/array_index.dart';
import 'package:rfc_6901/src/token/new_element.dart';
import 'package:rfc_6901/src/object_member.dart';
import 'package:rfc_6901/src/producer.dart';
import 'package:rfc_6901/src/token/reference_failure.dart';

/// A single JSON Pointer reference token
abstract class ReferenceToken {
  /// Creates a new instance from an unescaped expression.
  factory ReferenceToken(String unescapedExpression) =>
      NewElement.tryParse(unescapedExpression) ??
      ArrayIndex.tryParse(unescapedExpression) ??
      ObjectMember(unescapedExpression);

  /// Escapes a JSON Pointer token
  static String escape(String unescaped) =>
      unescaped.replaceAll('~', '~0').replaceAll('/', '~1');

  /// Unescapes a JSON Pointer token
  static String unescape(String escaped) =>
      escaped.replaceAll('~1', '/').replaceAll('~0', '~');

  /// Reads the referenced value from the [document].
  /// If no value is referenced, throws [ReferenceFailure].
  Object? read(document);

  /// Sets the referenced value in the [document] to the [newValue].
  /// When a non-existing [Map] (JSON Object) key is referred, it will be added to the map.
  /// When a new index in a [List] (JSON Array) is referred, it will be appended to the list.
  /// Otherwise throws [ReferenceFailure].
  void write(document, newValue);

  /// Reads the referenced value from the [document].
  /// If no value is referenced, and a new value can be created,
  /// sets the value created by [producer] and returns it.
  /// Otherwise throws [ReferenceFailure].
  Object? readOrCreate(document, Producer producer);

  /// Creates an empty document for which this reference is applicable.
  Object createEmptyDocument();
}
