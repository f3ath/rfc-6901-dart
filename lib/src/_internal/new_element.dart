import 'package:rfc_6901/src/_internal/object_member.dart';

/// A new element in a List
class NewElement extends ObjectMember {
  const NewElement() : super('-');

  static NewElement? tryParse(String unescapedExpression) {
    if (unescapedExpression == '-') return NewElement();
    return null;
  }

  @override
  Object? write(Object? document, Object? newValue) {
    if (document is List) {
      return [...document, newValue];
    }
    return super.write(document, newValue);
  }

  @override
  List emptyDocument() => [];
}
