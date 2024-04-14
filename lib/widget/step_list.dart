import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:nonogram/logic/nonogram.dart';
import 'package:nonogram/widget/nonogram_input.dart';

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
  IList<Nonogram> stateList = const IListConst([]);

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
          return const SizedBox(
            height: 128,
            child: CircularProgressIndicator(),
          );
        }
        final nonogram = stateList.getOrNull(index);
        if (nonogram == null) {
          final lastNonogram = stateList.lastOrNull ?? widget.value;
          final step = lastNonogram.nextStep();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (step != null) {
              setState(() {
                stateList = stateList.add(step.next);
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
              child: NonoGramInput(
                value: step.next,
                onChanged: (value) {},
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
              child: NonoGramInput(
                value: nonogram,
                onChanged: (value) {},
              ),
            )
          ],
        );
      },
    );
  }
}
