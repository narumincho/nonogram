import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:nonogram/logic/nonogram.dart';
import 'package:nonogram/widget/nonogram_view.dart';

class StepList extends StatefulWidget {
  const StepList({
    super.key,
    required this.value,
  });

  final Nonogram value;

  @override
  State<StatefulWidget> createState() => _StepListState();
}

class _StepListState extends State<StepList> {
  IList<({Nonogram nonogram, LineLocation location})> stateList =
      const IListConst([]);

  @override
  void initState() {
    super.initState();
    stateList = const IListConst([]);
  }

  @override
  void didUpdateWidget(StepList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        stateList = const IListConst([]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1000,
      itemBuilder: (context, index) {
        if (stateList.length < index) {
          return const SizedBox(height: 128);
        }
        final nonogram = stateList.getOrNull(index);
        if (nonogram == null) {
          final lastNonogram = stateList.lastOrNull?.nonogram ?? widget.value;
          final step = lastNonogram.nextStep();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (step != null) {
              setState(() {
                stateList = stateList.add((
                  nonogram: step.next,
                  location: step.location,
                ));
              });
            }
          });
          if (step == null) {
            return const Text('終了');
          }
          return Column(children: [
            const SizedBox(height: 16),
            Text('step: $index'),
            SizedBox(
              width: 256,
              height: 256,
              child: NonoGramView(
                value: step.next,
                location: step.location,
              ),
            ),
          ]);
        }
        return Column(
          children: [
            const SizedBox(height: 16),
            Text('step: $index'),
            SizedBox(
              width: 256,
              height: 256,
              child: NonoGramView(
                value: nonogram.nonogram,
                location: nonogram.location,
              ),
            )
          ],
        );
      },
    );
  }
}
