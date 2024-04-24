import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:nonogram/logic/nonogram.dart';

enum HightLightType {
  update,
  error,
}

class NonoGramView extends StatelessWidget {
  const NonoGramView({
    super.key,
    required this.value,
    required this.heightLights,
  });

  final Nonogram value;
  final ISet<({LineLocation location, HightLightType type})> heightLights;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = min(constraints.maxWidth, constraints.maxHeight);
      final hintSize = size * 0.3;
      final cellTableSize = size * 0.7;
      return Stack(children: [
        // 場所ハイライト
        for (final heightLight in heightLights)
          _hightLight(
            location: heightLight.location,
            cellTableSize: cellTableSize,
            hintSize: hintSize,
            size: size,
            color: switch (heightLight.type) {
              HightLightType.update => Colors.orange,
              HightLightType.error => Colors.red,
            },
          ),
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
            height: (index + 1) % 5 == 0 ? 2 : 1,
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
            width: (index + 1) % 5 == 0 ? 2 : 1,
            height: size,
            child: const DecoratedBox(
              decoration: BoxDecoration(color: Colors.black),
            ),
          ),
        // 列ヒント
        for (final (index, hints) in value.columnHints.indexed)
          Positioned(
            right: (value.columnSize - (index + 1)) *
                (cellTableSize / value.columnSize),
            top: 0,
            height: hintSize,
            child: Text(
              hints.join('\n'),
              overflow: TextOverflow.fade,
              style: TextStyle(
                  fontSize: cellTableSize / value.columnSize, height: 1),
              textAlign: TextAlign.right,
            ),
          ),
        // 行ヒント
        for (final (index, hints) in value.rowHints.indexed)
          Positioned(
            left: 0,
            top: hintSize + index * (cellTableSize / value.rowSize),
            width: hintSize,
            height: cellTableSize / value.rowSize,
            child: Text(
              hints.join(' '),
              textAlign: TextAlign.right,
              style: TextStyle(
                height: 1,
                fontSize: cellTableSize / value.rowSize,
              ),
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
              child: _CellView(cell: cell),
            ),
      ]);
    });
  }

  Widget _hightLight({
    required double hintSize,
    required double cellTableSize,
    required double size,
    required LineLocation location,
    required Color color,
  }) {
    switch (location.direction) {
      case Direction.row:
        return Positioned(
          left: 0,
          top: hintSize +
              location.index * (cellTableSize / value.rowHints.length),
          width: size,
          height: cellTableSize / value.rowHints.length,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
            ),
          ),
        );
      case Direction.column:
        return Positioned(
          left: hintSize +
              location.index * (cellTableSize / value.columnHints.length),
          top: 0,
          width: cellTableSize / value.rowHints.length,
          height: size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
            ),
          ),
        );
    }
  }
}

class _CellView extends StatelessWidget {
  const _CellView({
    super.key,
    required this.cell,
  });

  final Cell cell;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
    );
  }
}
