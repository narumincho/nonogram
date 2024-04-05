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
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Row(children: [
            const Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...value.rowHints.map(
                      (rowHint) => Expanded(
                        flex: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(border: Border.all()),
                          child: const Text('H'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
        Expanded(
          flex: 2,
          child: Row(children: [
            Expanded(
              flex: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(border: Border.all()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...value.columnHints.map(
                      (columnHint) => Expanded(
                        flex: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(border: Border.all()),
                          child: const Text('H'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(border: Border.all()),
                child: _CellsInput(
                  cells: value.cells,
                  onChanged: (newCells) {
                    onChanged(value.copyWithCells(newCells));
                  },
                ),
              ),
            )
          ]),
        )
      ],
    );
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
