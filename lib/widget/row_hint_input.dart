import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:narumincho_util/narumincho_util.dart';

class RowHintInput extends StatefulWidget {
  const RowHintInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final IList<int> value;
  final ValueChanged<IList<int>> onChanged;

  @override
  State<RowHintInput> createState() => _RowInputHintState();
}

class _RowInputHintState extends State<RowHintInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value.join(' ');
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(RowHintInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value.join(' ');
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      final values = _controller.text
          .split(RegExp(r'[^0-9]'))
          .mapAndRemoveNull((element) => int.tryParse(element))
          .toIList();
      widget.onChanged(values);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.end,
      controller: _controller,
      focusNode: _focusNode,
    );
  }
}
