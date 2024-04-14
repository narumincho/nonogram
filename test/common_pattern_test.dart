import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/logic/nonogram.dart';

import 'util.dart';

void main() {
  test('empty', () {
    sameTypeExpect<IList<Cell>>(
      createCommonPattern(const ISetConst({})),
      const IListConst([]),
    );
  });

  test('size 0 pattern 1', () {
    sameTypeExpect<IList<Cell>>(
      createCommonPattern(ISet(const [
        IListConst([]),
      ])),
      const IListConst([]),
    );
  });

  test('size 0 pattern 2', () {
    sameTypeExpect<IList<Cell>>(
      createCommonPattern(ISet(const [
        IListConst([]),
        IListConst([]),
      ])),
      const IListConst([]),
    );
  });

  test('size 1 empty', () {
    sameTypeExpect<IList<Cell>>(
      createCommonPattern(ISet(const [
        IListConst([false]),
      ])),
      const IListConst([Cell.empty]),
    );
  });

  test('size 1 fill', () {
    sameTypeExpect<IList<Cell>>(
      createCommonPattern(ISet(const [
        IListConst([true]),
      ])),
      const IListConst([Cell.filled]),
    );
  });

  test('size 1 unknown', () {
    sameTypeExpect<IList<Cell>>(
      createCommonPattern(ISet(const [
        IListConst([false]),
        IListConst([true]),
      ])),
      const IListConst([Cell.unknown]),
    );
  });

  test('size 1 empty 2', () {
    sameTypeExpect<IList<Cell>>(
      createCommonPattern(ISet(const [
        IListConst([false]),
        IListConst([false]),
      ])),
      const IListConst([Cell.empty]),
    );
  });

  test('size 1 fill 2', () {
    sameTypeExpect<IList<Cell>>(
      createCommonPattern(ISet(const [
        IListConst([true]),
        IListConst([true]),
      ])),
      const IListConst([Cell.filled]),
    );
  });

  test('size 2', () {
    sameTypeExpect<IList<Cell>>(
      createCommonPattern(ISet(const [
        IListConst([true, false]),
        IListConst([true, true]),
      ])),
      const IListConst([Cell.filled, Cell.unknown]),
    );
  });

  test('size 3', () {
    sameTypeExpect<IList<Cell>>(
      createCommonPattern(ISet(const [
        IListConst([true, false, false]),
        IListConst([true, true, false]),
        IListConst([true, true, false]),
      ])),
      const IListConst([Cell.filled, Cell.unknown, Cell.empty]),
    );
  });

  test('size different', () {
    sameTypeExpect<IList<Cell>>(
      createCommonPattern(ISet(const [
        IListConst([true]),
        IListConst([true, true]),
        IListConst([true, true, true]),
      ])),
      const IListConst([Cell.filled]),
    );
  });
}
