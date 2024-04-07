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
      print('constraints: ${(
        minWidth: constraints.minWidth,
        maxWidth: constraints.maxWidth,
        minHeight: constraints.minHeight,
        maxHeight: constraints.maxHeight,
      )}');
      final size = min(constraints.maxWidth, constraints.maxHeight);
      print('size: $size');
      return Stack(children: [
        Positioned(
          left: size * hintSizeRate,
          top: 0,
          width: size * (1 - hintSizeRate),
          height: size * hintSizeRate,
          child: DecoratedBox(
            decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
            child: Text('列ヒント'),
          ),
        ),
        Positioned(
          left: 0,
          top: size * hintSizeRate,
          width: size * hintSizeRate,
          height: size * (1 - hintSizeRate),
          child: DecoratedBox(
            decoration: BoxDecoration(border: Border.all()),
            child: Text('行ヒント'),
          ),
        ),
        Positioned(
          left: size * hintSizeRate,
          top: size * hintSizeRate,
          width: size * (1 - hintSizeRate),
          height: size * (1 - hintSizeRate),
          child: DecoratedBox(
            decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
            child: Text('セル'),
          ),
        ),
      ]);
      SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
          child: Text('input'),
        ),
      );
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
