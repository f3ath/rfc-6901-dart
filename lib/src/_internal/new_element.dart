import 'package:rfc_6901/src/_internal/object_member.dart';

/// A new element in a List
class NewElement extends ObjectMember {
  const NewElement() : super('-');

  static NewElement? tryParse(String unescapedExpression) =>
      unescapedExpression == '-' ? NewElement() : null;

  @override
  Object? write(Object? document, Object? newValue) => document is List
      ? [...document, newValue]
      : super.write(document, newValue);

  @override
  List emptyDocument() => [];
}
