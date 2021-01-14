/// Returns errors found in the [nonEmptyExpression].
/// The expression is considered valid when no errors are returned.
Iterable<String> validate(String nonEmptyExpression) sync* {
  if (!nonEmptyExpression.startsWith('/')) {
    yield 'Expression MUST start with "/".';
  }
  if (_danglingTilda.hasMatch(nonEmptyExpression)) {
    yield 'Tilda("~") MUST be followed by "0" or "1".';
  }
}

/// Represents a tilda with is not followed by "0" or "1"
final _danglingTilda = RegExp(r'~[^01]|~$');
