import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class Nonogram {
  const Nonogram._({
    required this.rowHints,
    required this.columnHints,
    required this.cells,
  });

  final IList<IList<int>> rowHints;
  final IList<IList<int>> columnHints;
  final IList<IList<bool>> cells;

  static Nonogram empty(int rowSize, int columnSize) {
    return Nonogram._(
      rowHints: IList(List.generate(rowSize, (_) => const IList.empty())),
      columnHints: IList(List.generate(columnSize, (_) => const IList.empty())),
      cells: IList(List.generate(
        rowSize,
        (_) => IList(List.generate(columnSize, (_) => false)),
      )),
    );
  }

  int get rowSize => rowHints.length;

  int get columnSize => columnHints.length;

  // TODO validate
  Nonogram copyWithCells(IList<IList<bool>> newCells) {
    return Nonogram._(
      rowHints: rowHints,
      columnHints: columnHints,
      cells: newCells,
    );
  }
}
