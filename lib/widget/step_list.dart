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
  IList<({Nonogram nonogram, LineLocation location})> stepList =
      const IListConst([]);

  @override
  void initState() {
    super.initState();
    stepList = const IListConst([]);
  }

  @override
  void didUpdateWidget(StepList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        stepList = const IListConst([]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stepList.length + 1,
      itemBuilder: (context, index) {
        if (stepList.length < index) {
          return const SizedBox(height: 128);
        }
        final nonogram = stepList.getOrNull(index);
        if (nonogram == null) {
          // 次のステップを計算
          final lastNonogram = stepList.lastOrNull?.nonogram ?? widget.value;
          final step = lastNonogram.nextStep();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (step != null) {
              setState(() {
                stepList = stepList.add((
                  nonogram: step.next,
                  location: step.location,
                ));
              });
            }
          });
          if (step == null) {
            if ((stepList.lastOrNull?.nonogram ?? widget.value).isComplete()) {
              return const Text('solved!', textAlign: TextAlign.center);
            }
            return const Text("couldn't solve it", textAlign: TextAlign.center);
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
