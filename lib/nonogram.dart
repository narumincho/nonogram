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
  final IList<IList<Cell>> cells;

  static Nonogram empty(int rowSize, int columnSize) {
    return Nonogram._(
      rowHints: IList(List.generate(rowSize, (_) => const IList.empty())),
      columnHints: IList(List.generate(columnSize, (_) => const IList.empty())),
      cells: IList(List.generate(
        rowSize,
        (_) => IList(List.generate(columnSize, (_) => Cell.unknown)),
      )),
    );
  }

  int get rowSize => rowHints.length;

  int get columnSize => columnHints.length;

  // TODO validate
  Nonogram copyWithCells(IList<IList<Cell>> newCells) {
    return Nonogram._(
      rowHints: rowHints,
      columnHints: columnHints,
      cells: newCells,
    );
  }

  Nonogram replaceCellAt(int row, int column, Cell newCell) {
    return copyWithCells(cells.replace(
      row,
      cells[row].replace(column, newCell),
    ));
  }

  Nonogram replaceRowHintsAt(int index, IList<int> newHints) {
    return Nonogram._(
      rowHints: rowHints.replace(index, newHints),
      columnHints: columnHints,
      cells: cells,
    );
  }

  Nonogram replaceColumnHintsAt(int index, IList<int> newHints) {
    return Nonogram._(
      rowHints: rowHints,
      columnHints: columnHints.replace(index, newHints),
      cells: cells,
    );
  }

  NonogramLine getLine(LineLocation location) {
    final hints = location.direction == Direction.row
        ? rowHints[location.index]
        : columnHints[location.index];

    return NonogramLine(
      hints: hints,
      cells: location.direction == Direction.row
          ? cells[location.index]
          : IList(
              List.generate(
                rowSize,
                (index) => cells[index][location.index],
              ),
            ),
    );
  }

  IList<LineLocation> indexes() {
    return IList([
      for (int i = 0; i < rowSize; i++)
        LineLocation(direction: Direction.row, index: i),
      for (int i = 0; i < columnSize; i++)
        LineLocation(direction: Direction.column, index: i),
    ]);
  }

  Iterable<T> map<T>(T Function(LineLocation, NonogramLine) func) {
    return indexes().map((location) => func(location, getLine(location)));
  }
}

enum Cell {
  empty,
  filled,
  unknown,
}

enum Direction {
  row,
  column,
}

@immutable
class Step {
  const Step({
    required this.location,
    required this.patterns,
    required this.result,
  });

  final LineLocation location;
  final IList<NonogramLine> patterns;
  final NonogramLine result;
}

@immutable
class LineLocation {
  const LineLocation({
    required this.direction,
    required this.index,
  });

  final Direction direction;
  final int index;
}

@immutable
class NonogramLine {
  const NonogramLine({
    required this.hints,
    required this.cells,
  });

  final IList<int> hints;
  final IList<Cell> cells;

  bool isComplete() => cells.every((cell) => cell != Cell.unknown);
}
