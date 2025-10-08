import 'package:rfc_6901/src/_internal/array_index.dart';
import 'package:rfc_6901/src/_internal/new_element.dart';
import 'package:rfc_6901/src/_internal/object_member.dart';
import 'package:rfc_6901/src/_internal/reference_failure.dart';

/// A single JSON Pointer reference
abstract class Reference {
  /// Creates a new instance from an unescaped token.
  factory Reference(String token) =>
      NewElement.tryParse(token) ??
      ArrayIndex.tryParse(token) ??
      ObjectMember(token);

  /// Escapes a JSON Pointer token
  static String escape(String unescaped) =>
      unescaped.replaceAll('~', '~0').replaceAll('/', '~1');

  /// Unescapes a JSON Pointer token
  static String unescape(String escaped) =>
      escaped.replaceAll('~1', '/').replaceAll('~0', '~');

  /// Reads the referenced value from the [document].
  /// If no value is referenced, throws [ReferenceFailure].
  Object? read(Object? document);

  /// Returns a copy of the [document] with the referenced value set to [newValue].
  /// When a non-existing [Map] (JSON Object) key is referred, it will be added to the map.
  /// When a new index in a [List] (JSON Array) is referred, it will be appended to the list.
  /// Otherwise throws [ReferenceFailure].
  Object? write(Object? document, Object? newValue);

  /// Returns a copy of the [document] with the referenced value set to [newValue].
  /// When a non-existing [Map] (JSON Object) key is referred, it will be added to the map.
  /// When an existing index in a [List] (JSON Array) is referred,
  /// it will be set to [newValue] and existing elements at or above the index will be shifted to the right.
  /// When a new index in a [List] (JSON Array) is referred ("-"), it will be appended to the list.
  /// Otherwise throws [ReferenceFailure].
  Object? add(Object? document, Object? newValue);

  /// Returns a copy of the [document] with the referenced value removed.
  /// When an existing [Map] (JSON Object) key is referred, it will be removed from the map.
  /// When an existing index in a [List] (JSON Array) is referred,
  /// it will be removed and the elements above the index will be shifted to the left.
  /// Otherwise throws [ReferenceFailure].
  Object? remove(Object? document);

  /// Creates an empty document for which this reference is applicable.
  Object emptyDocument();
}
