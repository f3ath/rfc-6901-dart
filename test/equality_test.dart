import 'package:rfc_6901/rfc_6901.dart';
import 'package:rfc_6901/src/_internal/empty_json_pointer.dart';
import 'package:test/test.dart';

void main() {
  test('Pointer equality', () {
    var thisPointer = JsonPointer('/root');
    var thatPointer = JsonPointer('/root');
    var differentPointer = JsonPointer('/different/one');
    var explicitEmptyPointer = EmptyJsonPointer();
    var emptyPointer = JsonPointer();

    expect(thisPointer == thatPointer, true);
    expect(emptyPointer == explicitEmptyPointer, true);
    expect(thisPointer != differentPointer, true);

    expect(thisPointer.hashCode == thatPointer.hashCode, true);
    expect(emptyPointer.hashCode == explicitEmptyPointer.hashCode, true);
    expect(thisPointer.hashCode != differentPointer.hashCode, true);
  });
}
