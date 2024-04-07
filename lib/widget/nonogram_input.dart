import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nonogram/nonogram.dart';

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
      const hintSizeRate = 0.3;
      final size = min(constraints.maxWidth, constraints.maxHeight);
      return Stack(children: [
        // 横線
        Positioned(
          left: 0,
          top: size * hintSizeRate - 1,
          width: size,
          height: 2,
          child: const DecoratedBox(
              decoration: BoxDecoration(color: Colors.black)),
        ),
        // 縦線
        Positioned(
          left: size * hintSizeRate - 1,
          top: 0,
          width: 2,
          height: size,
          child: const DecoratedBox(
              decoration: BoxDecoration(color: Colors.black)),
        ),
        Positioned(
          left: size * hintSizeRate,
          top: 0,
          width: size * (1 - hintSizeRate),
          height: size * hintSizeRate,
          child: const Text('列ヒント'),
        ),
        Positioned(
          left: 0,
          top: size * hintSizeRate,
          width: size * hintSizeRate,
          height: size * (1 - hintSizeRate),
          child: const Text('行ヒント'),
        ),
        Positioned(
          left: size * hintSizeRate,
          top: size * hintSizeRate,
          width: size * (1 - hintSizeRate),
          height: size * (1 - hintSizeRate),
          child: const Text('セル'),
        ),
        // 横線
        for (final (index, _) in value.rowHints.indexed)
          Positioned(
            left: 0,
            top: size * hintSizeRate +
                (1 + index) *
                    (size * (1 - hintSizeRate) / (value.rowHints.length + 1)),
            width: size,
            height: (index + 1) % 5 == 0 ? 3 : 1,
            child: const DecoratedBox(
              decoration: BoxDecoration(color: Colors.black),
            ),
          ),
        // 縦線
        for (final (index, _) in value.columnHints.indexed)
          Positioned(
            left: size * hintSizeRate +
                (1 + index) *
                    (size *
                        (1 - hintSizeRate) /
                        (value.columnHints.length + 1)),
            top: 0,
            width: (index + 1) % 5 == 0 ? 3 : 1,
            height: size,
            child: const DecoratedBox(
              decoration: BoxDecoration(color: Colors.black),
            ),
          ),
      ]);
    });
  }
}

class _CellsInput extends StatelessWidget {
  const _CellsInput({
    super.key,
    required this.cells,
    required this.onChanged,
  });

  final IList<IList<bool>> cells;
  final ValueChanged<IList<IList<bool>>> onChanged;

  @override
  Widget build(BuildContext context) {
    return GridView.count(crossAxisCount: cells.length, children: [
      ...List.generate(
        cells.length * cells.map((row) => row.length).reduce(max),
        (_) => DecoratedBox(decoration: BoxDecoration(border: Border.all())),
      )
    ]);
  }
}
