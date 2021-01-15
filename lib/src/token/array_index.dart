import 'package:rfc_6901/src/object_member.dart';
import 'package:rfc_6901/src/producer.dart';

/// A reference to a value in a List or Map
class ArrayIndex extends ObjectMember {
  ArrayIndex(this.index) : super(index.toString());

  /// Returns an instance of ArrayIndex if it can be parsed from the [unescapedExpression].
  static ArrayIndex? tryParse(String unescapedExpression) {
    if (regex.hasMatch(unescapedExpression)) {
      return ArrayIndex(int.parse(unescapedExpression));
    }
  }

  /// Array index regex. An array index MUST be either "0" or an unsigned
  /// base-10 integer starting with a non-zero digit.
  static final regex = RegExp(r'^(0|([1-9][0-9]*))$');

  /// int value of the index.
  final int index;

  @override
  Object? read(Object? document) {
    if (document is List && _applicableTo(document)) {
      return document[index];
    }
    return super.read(document);
  }

  @override
  void write(Object? document, Object? value) {
    if (document is List && _applicableTo(document)) {
      document[index] = value;
    } else {
      super.write(document, value);
    }
  }

  @override
  Object? readOrCreate(Object? document, Producer producer) {
    if (document is List && _applicableTo(document)) {
      return document[index];
    }
    return super.readOrCreate(document, producer);
  }

  bool _applicableTo(List document) => index >= 0 && index < document.length;
}
