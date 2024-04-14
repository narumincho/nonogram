import 'package:flutter/material.dart';

class SizeInput extends StatefulWidget {
  const SizeInput({
    super.key,
    required this.columnSize,
    required this.rowSize,
    required this.onColumnSizeChanged,
    required this.onRowSizeChanged,
  });

  final int columnSize;
  final int rowSize;
  final ValueChanged<int> onColumnSizeChanged;
  final ValueChanged<int> onRowSizeChanged;

  @override
  State<SizeInput> createState() => _SizeInputState();
}

class _SizeInputState extends State<SizeInput> {
  final TextEditingController _controllerColumnSize = TextEditingController();
  final _controllerRowSize = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllerColumnSize.text = widget.columnSize.toString();
    _controllerRowSize.text = widget.rowSize.toString();
    _controllerColumnSize.addListener(() {
      final newColumnSize = int.tryParse(_controllerColumnSize.text);
      if (newColumnSize != null) {
        widget.onColumnSizeChanged(newColumnSize);
      }
    });
    _controllerRowSize.addListener(() {
      final newRowSize = int.tryParse(_controllerRowSize.text);
      if (newRowSize != null) {
        widget.onRowSizeChanged(newRowSize);
      }
    });
  }

  @override
  void didUpdateWidget(SizeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.columnSize != widget.columnSize) {
      _controllerColumnSize.text = widget.columnSize.toString();
    }
    if (oldWidget.rowSize != widget.rowSize) {
      _controllerRowSize.text = widget.rowSize.toString();
    }
  }

  @override
  void dispose() {
    _controllerColumnSize.dispose();
    _controllerRowSize.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: TextField(
          controller: _controllerColumnSize,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Column Size',
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: TextField(
          controller: _controllerRowSize,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Row Size',
          ),
        ),
      ),
    ]);
  }
}
