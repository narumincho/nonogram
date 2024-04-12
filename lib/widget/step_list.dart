import 'package:flutter/material.dart';
import 'package:nonogram/nonogram.dart';

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
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1000,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Step $index'),
        );
      },
    );
  }
}
