import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:narumincho_util/narumincho_util.dart';
import 'package:nonogram/logic/nonogram.dart';
import 'package:nonogram/logic/result.dart';
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
  IList<StepResult> stepList = const IListConst([]);

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

  Nonogram lastNonogram() {
    return stepList.reversed.mapFirstNotNull((step) => switch (step) {
              Ok(value: null) => null,
              Ok(:final value?) => value.next,
              Error() => null,
            }) ??
        widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stepList.length + 1,
      itemBuilder: (context, index) {
        switch (stepList.getOrNull(index)) {
          case null:
            switch (stepList.lastOrNull) {
              case null:
                final stepResult = widget.value.nextStep();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    stepList = stepList.add(stepResult);
                  });
                });
                return _StepResultView(
                  result: stepResult,
                  nonogram: lastNonogram(),
                  stepNumber: index,
                );
              case Ok(value: null) || Error():
                return const SizedBox();
              case Ok(:final value?):
                final stepResult = value.next.nextStep();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    stepList = stepList.add(stepResult);
                  });
                });
                return _StepResultView(
                  result: stepResult,
                  nonogram: lastNonogram(),
                  stepNumber: index,
                );
            }
          case final result:
            return _StepResultView(
              result: result,
              nonogram: lastNonogram(),
              stepNumber: index,
            );
        }
      },
    );
  }
}

class _StepResultView extends StatelessWidget {
  const _StepResultView({
    required this.result,
    required this.nonogram,
    required this.stepNumber,
  });

  final StepResult result;
  final Nonogram nonogram;
  final int stepNumber;

  @override
  Widget build(BuildContext context) {
    switch (result) {
      case Ok(value: null):
        return const _StepCompleteView();
      case Ok(:final value?):
        return _StepView(
          stepNumber: stepNumber,
          location: value.location,
          nonogram: value.next,
        );
      case Error(:final value):
        return Column(children: [
          const SizedBox(height: 16),
          Text('step: $stepNumber cannot solve'),
          SizedBox(
            width: 256,
            height: 256,
            child: NonoGramView(
              value: nonogram,
              heightLights: value
                  .map(
                    (location) => (
                      location: location,
                      type: HightLightType.error,
                    ),
                  )
                  .toISet(),
            ),
          ),
        ]);
    }
  }
}

class _StepView extends StatelessWidget {
  const _StepView({
    required this.stepNumber,
    required this.location,
    required this.nonogram,
  });

  final int stepNumber;
  final LineLocation location;
  final Nonogram nonogram;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 16),
      Text('step: $stepNumber'),
      SizedBox(
        width: 256,
        height: 256,
        child: NonoGramView(
          value: nonogram,
          heightLights: ISet({
            (
              location: location,
              type: HightLightType.update,
            )
          }),
        ),
      ),
    ]);
  }
}

class _StepCompleteView extends StatelessWidget {
  const _StepCompleteView();

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      SizedBox(height: 16),
      SizedBox(width: 256, height: 256, child: Center(child: Text('solved!'))),
    ]);
  }
}
