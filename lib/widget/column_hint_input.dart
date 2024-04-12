import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:narumincho_util/narumincho_util.dart';

class ColumnHintInput extends StatefulWidget {
  const ColumnHintInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final IList<int> value;
  final ValueChanged<IList<int>> onChanged;

  @override
  State<ColumnHintInput> createState() => _ColumnInputHintState();
}

class _ColumnInputHintState extends State<ColumnHintInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value.join('\n');
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(ColumnHintInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value.join('\n');
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
      keyboardType: TextInputType.multiline,
      maxLines: 99,
      textAlign: TextAlign.end,
      controller: _controller,
      focusNode: _focusNode,
    );
  }
}
