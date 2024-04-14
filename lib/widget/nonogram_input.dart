import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nonogram/logic/nonogram.dart';
import 'package:nonogram/widget/column_hint_input.dart';
import 'package:nonogram/widget/row_hint_input.dart';

class NonoGramInput extends StatelessWidget {
  const NonoGramInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Nonogram value;
  final ValueChanged<Nonogram> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = min(constraints.maxWidth, constraints.maxHeight);
      final hintSize = size * 0.3;
      final cellTableSize = size * 0.6;
      return Stack(children: [
        // 横線
        Positioned(
          left: 0,
          top: hintSize - 1,
          width: size,
          height: 2,
          child: const DecoratedBox(
              decoration: BoxDecoration(color: Colors.black)),
        ),
        // 縦線
        Positioned(
          left: hintSize - 1,
          top: 0,
          width: 2,
          height: size,
          child: const DecoratedBox(
            decoration: BoxDecoration(color: Colors.black),
          ),
        ),
        // 横線
        for (final (index, _) in value.rowHints.indexed)
          Positioned(
            left: 0,
            top: hintSize +
                (1 + index) * (cellTableSize / value.rowHints.length),
            width: size,
            height: (index + 1) % 5 == 0 ? 3 : 1,
            child: const DecoratedBox(
              decoration: BoxDecoration(color: Colors.black),
            ),
          ),
        // 縦線
        for (final (index, _) in value.columnHints.indexed)
          Positioned(
            left: hintSize +
                (1 + index) * (cellTableSize / value.columnHints.length),
            top: 0,
            width: (index + 1) % 5 == 0 ? 3 : 1,
            height: size,
            child: const DecoratedBox(
              decoration: BoxDecoration(color: Colors.black),
            ),
          ),
        // 列ヒント
        for (final (index, hints) in value.columnHints.indexed)
          Positioned(
            left: hintSize + index * (cellTableSize / value.columnSize),
            top: 0,
            width: cellTableSize / value.columnSize,
            height: hintSize,
            child: ColumnHintInput(
              value: hints,
              onChanged: (newHints) {
                onChanged(value.replaceColumnHintsAt(index, newHints));
              },
            ),
          ),
        // 行ヒント
        for (final (index, hints) in value.rowHints.indexed)
          Positioned(
            left: 0,
            top: hintSize + index * (cellTableSize / value.rowSize),
            width: hintSize,
            height: cellTableSize / value.rowSize,
            child: RowHintInput(
              value: hints,
              onChanged: (newHints) {
                onChanged(value.replaceRowHintsAt(index, newHints));
              },
            ),
          ),
        // セル
        for (final (rowIndex, row) in value.cells.indexed)
          for (final (columnIndex, cell) in row.indexed)
            Positioned(
              left: hintSize + columnIndex * (cellTableSize / value.columnSize),
              top: hintSize + rowIndex * (cellTableSize / value.rowSize),
              width: cellTableSize / value.columnSize,
              height: cellTableSize / value.rowSize,
              child: _CellInput(
                cell: cell,
                onChanged: (newCell) {
                  onChanged(value.replaceCellAt(
                    rowIndex,
                    columnIndex,
                    newCell,
                  ));
                },
              ),
            ),
      ]);
    });
  }
}

class _CellInput extends StatelessWidget {
  const _CellInput({
    super.key,
    required this.cell,
    required this.onChanged,
  });

  final Cell cell;
  final ValueSetter<Cell> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (d) {
        switch (cell) {
          case Cell.empty:
            onChanged(Cell.unknown);
            break;
          case Cell.filled:
            onChanged(Cell.empty);
            break;
          case Cell.unknown:
            onChanged(Cell.filled);
            break;
        }
      },
      onSecondaryTapDown: (d) {
        switch (cell) {
          case Cell.empty:
            onChanged(Cell.unknown);
            return;
          case Cell.filled:
          case Cell.unknown:
            onChanged(Cell.empty);
            return;
        }
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: switch (cell) {
            Cell.unknown => Colors.transparent,
            Cell.filled => Colors.black,
            Cell.empty => Colors.transparent,
          },
        ),
        child: switch (cell) {
          Cell.unknown => null,
          Cell.filled => null,
          Cell.empty => LayoutBuilder(
              builder: (context, constraints) =>
                  Icon(Icons.close, size: constraints.maxWidth),
            ),
        },
      ),
    );
  }
}
