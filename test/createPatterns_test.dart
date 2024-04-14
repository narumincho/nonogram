import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/logic/hint_number.dart';
import 'package:nonogram/logic/nonogram.dart';

void main() {
  test('size 0, hint []', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(const IListConst([]), 0),
      const IListConst([IListConst([])]),
    );
  });

  test('size 0, hint [1]', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(IList([HintNumber.fromInt(1)]), 0),
      const IListConst([]),
    );
  });

  test('size 1, hint []', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(const IListConst([]), 1),
      const IListConst([
        IListConst([false]),
      ]),
    );
  });

  test('size 1, hint [1]', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(IList([HintNumber.fromInt(1)]), 1),
      const IListConst([
        IListConst([true]),
      ]),
    );
  });

  test('size 1, hint [2]', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(IList([HintNumber.fromInt(2)]), 1),
      const IListConst([]),
    );
  });

  test('size 2, hint []', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(const IListConst([]), 2),
      const IListConst([
        IListConst([false, false]),
      ]),
    );
  });

  test('size 2, hint [1]', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(IList([HintNumber.fromInt(1)]), 2),
      const IListConst([
        IListConst([true, false]),
        IListConst([false, true]),
      ]),
    );
  });

  test('size 2, hint [2]', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(IList([HintNumber.fromInt(2)]), 2),
      const IListConst([
        IListConst([true, true]),
      ]),
    );
  });

  test('size 2, hint [3]', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(IList([HintNumber.fromInt(3)]), 2),
      const IListConst([]),
    );
  });

  test('size 2, hint [1, 1]', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(
        IList([
          HintNumber.fromInt(1),
          HintNumber.fromInt(1),
        ]),
        2,
      ),
      const IListConst([]),
    );
  });

  test('size 3, hint []', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(
        const IListConst([]),
        3,
      ),
      const IListConst([
        IListConst([false, false, false]),
      ]),
    );
  });

  test('size 3, hint [1]', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(
        IList([
          HintNumber.fromInt(1),
        ]),
        3,
      ),
      const IListConst([
        IListConst([true, false, false]),
        IListConst([false, true, false]),
        IListConst([false, false, true]),
      ]),
    );
  });

  test('size 3, hint [2]', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(
        IList([
          HintNumber.fromInt(2),
        ]),
        3,
      ),
      const IListConst([
        IListConst([true, true, false]),
        IListConst([false, true, true]),
      ]),
    );
  });

  test('size 3, hint [3]', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(
        IList([HintNumber.fromInt(3)]),
        3,
      ),
      const IListConst([
        IListConst([true, true, true]),
      ]),
    );
  });

  test('size 3, hint [1, 1]', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(
        IList([HintNumber.fromInt(1), HintNumber.fromInt(1)]),
        3,
      ),
      const IListConst([
        IListConst([true, false, true]),
      ]),
    );
  });

  test('size 3, hint [1, 2]', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(
        IList([HintNumber.fromInt(1), HintNumber.fromInt(2)]),
        3,
      ),
      const IListConst([]),
    );
  });

  test('size 3, hint [4]', () {
    _sameTypeExpect<IList<IList<bool>>>(
      createPatterns(
        IList([HintNumber.fromInt(4)]),
        3,
      ),
      const IListConst([]),
    );
  });
}

void _sameTypeExpect<T>(T actual, T expected) {
  expect(actual, expected);
}
