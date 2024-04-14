import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/logic/hint_number.dart';
import 'package:nonogram/logic/nonogram.dart';

import 'util.dart';

void main() {
  test('size 0, hint []', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(const IListConst([]), 0),
      ISet(const [IListConst([])]),
    );
  });

  test('size 0, hint [1]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(IList([HintNumber.fromInt(1)]), 0),
      const ISetConst({}),
    );
  });

  test('size 1, hint []', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(const IListConst([]), 1),
      ISet(const [
        IListConst([false]),
      ]),
    );
  });

  test('size 1, hint [1]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(IList([HintNumber.fromInt(1)]), 1),
      ISet(const [
        IListConst([true]),
      ]),
    );
  });

  test('size 1, hint [2]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(IList([HintNumber.fromInt(2)]), 1),
      const ISetConst({}),
    );
  });

  test('size 2, hint []', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(const IListConst([]), 2),
      ISet(const [
        IListConst([false, false]),
      ]),
    );
  });

  test('size 2, hint [1]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(IList([HintNumber.fromInt(1)]), 2),
      ISet(const [
        IListConst([true, false]),
        IListConst([false, true]),
      ]),
    );
  });

  test('size 2, hint [2]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(IList([HintNumber.fromInt(2)]), 2),
      ISet(const [
        IListConst([true, true]),
      ]),
    );
  });

  test('size 2, hint [3]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(IList([HintNumber.fromInt(3)]), 2),
      const ISetConst({}),
    );
  });

  test('size 2, hint [1, 1]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(
        IList([
          HintNumber.fromInt(1),
          HintNumber.fromInt(1),
        ]),
        2,
      ),
      const ISetConst({}),
    );
  });

  test('size 3, hint []', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(
        const IListConst([]),
        3,
      ),
      ISet(const [
        IListConst([false, false, false]),
      ]),
    );
  });

  test('size 3, hint [1]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(
        IList([
          HintNumber.fromInt(1),
        ]),
        3,
      ),
      ISet(const [
        IListConst([true, false, false]),
        IListConst([false, true, false]),
        IListConst([false, false, true]),
      ]),
    );
  });

  test('size 3, hint [2]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(
        IList([
          HintNumber.fromInt(2),
        ]),
        3,
      ),
      ISet(const [
        IListConst([true, true, false]),
        IListConst([false, true, true]),
      ]),
    );
  });

  test('size 3, hint [3]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(
        IList([HintNumber.fromInt(3)]),
        3,
      ),
      ISet(const [
        IListConst([true, true, true]),
      ]),
    );
  });

  test('size 3, hint [1, 1]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(
        IList([HintNumber.fromInt(1), HintNumber.fromInt(1)]),
        3,
      ),
      ISet(const [
        IListConst([true, false, true]),
      ]),
    );
  });

  test('size 3, hint [1, 2]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(
        IList([HintNumber.fromInt(1), HintNumber.fromInt(2)]),
        3,
      ),
      const ISetConst({}),
    );
  });

  test('size 3, hint [4]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(
        IList([HintNumber.fromInt(4)]),
        3,
      ),
      const ISetConst({}),
    );
  });

  test('size 4, hint [1, 1]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(
        IList([HintNumber.fromInt(1), HintNumber.fromInt(1)]),
        4,
      ),
      ISet(const [
        IListConst([true, false, true, false]),
        IListConst([true, false, false, true]),
        IListConst([false, true, false, true]),
      ]),
    );
  });

  test('size 4, hint [1, 2]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(
        IList([HintNumber.fromInt(1), HintNumber.fromInt(2)]),
        4,
      ),
      ISet(const [
        IListConst([true, false, true, true]),
      ]),
    );
  });

  test('size 4, hint [2, 1]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(
        IList([HintNumber.fromInt(2), HintNumber.fromInt(1)]),
        4,
      ),
      ISet(const [
        IListConst([true, true, false, true]),
      ]),
    );
  });

  test('size 4, hint [1, 1, 1]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(
        IList([
          HintNumber.fromInt(1),
          HintNumber.fromInt(1),
          HintNumber.fromInt(1),
        ]),
        4,
      ),
      const ISetConst({}),
    );
  });

  test('size 10, hint [8]', () {
    sameTypeExpect<ISet<IList<bool>>>(
      createPatterns(
        IList([HintNumber.fromInt(8)]),
        10,
      ),
      ISet(const [
        IListConst(
          [true, true, true, true, true, true, true, true, false, false],
        ),
        IListConst(
          [false, true, true, true, true, true, true, true, true, false],
        ),
        IListConst(
          [false, false, true, true, true, true, true, true, true, true],
        ),
      ]),
    );
  });
}
