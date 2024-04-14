import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/logic/hint_number.dart';
import 'package:nonogram/logic/nonogram.dart';

void main() {
  test('createPatterns size 0, hint empty', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(const IListConst([]), 0),
      const IListConst([IListConst([])]),
    );
  });

  test('createPatterns size 0, hint [1]', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(IList([HintNumber.fromInt(1)]), 0),
      const IListConst([]),
    );
  });
}

void _sameTypeExpect<T>(T actual, T expected) {
  expect(actual, expected);
}
