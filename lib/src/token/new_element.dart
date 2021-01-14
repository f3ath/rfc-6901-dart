import 'package:rfc_6901/src/object_member.dart';
import 'package:rfc_6901/src/producer.dart';

/// A new element in a List
class NewElement extends ObjectMember {
  NewElement() : super('-');

  static NewElement? tryParse(String unescapedExpression) {
    if (unescapedExpression == '-') return NewElement();
  }

  @override
  void write(document, value) {
    if (document is List) {
      document.add(value);
    } else {
      super.write(document, value);
    }
  }

  @override
  List createEmptyDocument() => [];

  @override
  Object? readOrCreate(Object? document, Producer producer) {
    if (document is List) {
      final value = producer();
      document.add(value);
      return value;
    }
    return super.readOrCreate(document, producer);
  }
}
