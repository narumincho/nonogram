import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:narumincho_util/narumincho_util.dart';
import 'package:nonogram/logic/hint_number.dart';
import 'package:collection/collection.dart';

@immutable
class Nonogram {
  const Nonogram._({
    required this.rowHints,
    required this.columnHints,
    required this.cells,
  });

  final IList<IList<HintNumber>> rowHints;
  final IList<IList<HintNumber>> columnHints;
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

  Nonogram setRowSize(int size) {
    final clampedSize = min(max(1, size), 256);
    return Nonogram._(
      rowHints: rowHints
          .setMinLength(clampedSize, const IListConst([]))
          .take(clampedSize)
          .toIList(),
      columnHints: columnHints,
      cells: cells
          .setMinLength(
            clampedSize,
            List.generate(columnSize, (index) => Cell.unknown).toIList(),
          )
          .take(clampedSize)
          .toIList(),
    );
  }

  Nonogram setColumnSize(int size) {
    final clampedSize = min(max(1, size), 256);
    return Nonogram._(
      rowHints: rowHints,
      columnHints: columnHints
          .setMinLength(clampedSize, const IListConst([]))
          .take(clampedSize)
          .toIList(),
      cells: cells
          .map(
            (cellLine) =>
                cellLine.setMinLength(clampedSize, Cell.unknown).toIList(),
          )
          .toIList(),
    );
  }

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

  Nonogram replaceRowHintsAt(int index, IList<HintNumber> newHints) {
    return Nonogram._(
      rowHints: rowHints.replace(index, newHints),
      columnHints: columnHints,
      cells: cells,
    );
  }

  Nonogram replaceColumnHintsAt(int index, IList<HintNumber> newHints) {
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

  Nonogram replaceCellsOnLine(LineLocation location, IList<Cell> cells) {
    return Nonogram._(
      rowHints: rowHints,
      columnHints: columnHints,
      cells: switch (location.direction) {
        Direction.row => this.cells.replace(location.index, cells),
        Direction.column => this
            .cells
            .zipU(cells)
            .map((tuple) => tuple.$1.replace(location.index, tuple.$2))
            .toIList(),
      },
    );
  }

  IList<LineLocation> indexes() {
    return IList([
      ...List.generate(
        rowSize,
        (index) => LineLocation(direction: Direction.row, index: index),
      ),
      ...List.generate(
        columnSize,
        (index) => LineLocation(direction: Direction.column, index: index),
      ),
    ]);
  }

  Iterable<T> map<T>(
      T Function(LineLocation location, NonogramLine line) func) {
    return indexes().map((location) => func(location, getLine(location)));
  }

  ({Nonogram next, LineLocation location})? nextStep() {
    final nextLocationAndCells = maxBy(
      map((location, line) => (
            location: location,
            prev: line.cells,
            next: createCommonPattern(
              createPatterns(line.hints, line.cells.length)
                  .where((element) => satisfyCells(element, line.cells))
                  .toISet(),
            )
          )),
      (tuple) => fillCount(tuple.prev, tuple.next),
    );
    if (nextLocationAndCells == null) {
      return null;
    }
    if (fillCount(
          getLine(nextLocationAndCells.location).cells,
          nextLocationAndCells.next,
        ) ==
        0) {
      return null;
    }

    return (
      location: nextLocationAndCells.location,
      next: replaceCellsOnLine(
        nextLocationAndCells.location,
        nextLocationAndCells.next,
      )
    );
  }
}

enum Cell {
  empty,
  filled,
  unknown,
}

enum Direction {
  /// →
  row,

  /// ↓
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

  final IList<HintNumber> hints;
  final IList<Cell> cells;

  bool isComplete() => cells.every((cell) => cell != Cell.unknown);
}

/// ヒントからすべてのパターンを生成
ISet<IList<bool>> createPatterns(IList<HintNumber> hints, int size) {
  if (size < 0) {
    return const ISetConst({});
  }
  final minSize = getMinSizeByHints(hints);
  if (size < minSize) {
    return const ISetConst({});
  }
  final firstHint = hints.firstOrNull;
  if (firstHint == null) {
    return ISet({
      List.generate(size, (_) => false).toIList(),
    });
  }
  final hintsTail = hints.tail.toIList();
  if (hintsTail.isEmpty) {
    return ISet(
      List.generate(
        size - firstHint.value + 1,
        (index) => IList([
          ...List.generate(index, (index) => false),
          ...List.generate(firstHint.value, (index) => true),
          ...List.generate(size - (firstHint.value + index), (index) => false),
        ]),
      ),
    );
  }
  return ISet(
    List.generate(
        (size - (1 + getMinSizeByHints(hintsTail))) - firstHint.value + 1,
        (index) => index).expand<IList<bool>>(
      (index) =>
          createPatterns(hintsTail, size - (firstHint.value + 1 + index)).map(
        (tailPattern) => IList<bool>([
          ...List.generate(index, (index) => false),
          ...List.generate(firstHint.value, (index) => true),
          false,
          ...tailPattern,
        ]),
      ),
    ),
  );
}

/// ヒントから最小のサイズを取得
int getMinSizeByHints(IList<HintNumber> hints) {
  return max(hints.sumBy((hint) => hint.value) + hints.length - 1, 0);
}

/// パターンが条件を満たすか
bool satisfyCells(IList<bool> target, IList<Cell> cells) {
  return target.zipU(cells).every((tuple) => switch (tuple) {
        (_, Cell.unknown) => true,
        (true, Cell.filled) => true,
        (false, Cell.filled) => false,
        (true, Cell.empty) => false,
        (false, Cell.empty) => true,
      });
}

/// パターンから共通のパターンを生成
IList<Cell> createCommonPattern(ISet<IList<bool>> patterns) {
  return IterableZip(patterns)
      .map(
        (cells) => cells.every((cell) => cell)
            ? Cell.filled
            : cells.every((cell) => !cell)
                ? Cell.empty
                : Cell.unknown,
      )
      .toIList();
}

/// 埋めることができた数
int fillCount(IList<Cell> previous, IList<Cell> current) {
  return previous
      .zip(current)
      .where((tuple) =>
          tuple.$1 == Cell.unknown &&
          (tuple.$2 == Cell.filled || tuple.$2 == Cell.empty))
      .length;
}

/// https://github.com/marcglasberg/fast_immutable_collections/pull/77
/// がマージされるまでの処理
extension Zip<T> on IList<T> {
  Iterable<(T, U)> zipU<U>(Iterable<U> otherIterable) {
    final other = otherIterable.toList();
    final minLength = min(length, other.length);
    return Iterable.generate(minLength, (index) => (this[index], other[index]));
  }
}
