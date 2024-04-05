import 'package:flutter/material.dart';
import 'package:nonogram/nonogram.dart';
import 'package:nonogram/widget/nonogram_input.dart';

void main() {
  runApp(const NonogramApp());
}

class NonogramApp extends StatefulWidget {
  const NonogramApp({super.key});

  @override
  State<NonogramApp> createState() => _NonogramAppState();
}

class _NonogramAppState extends State<NonogramApp> {
  Nonogram _nonogram = Nonogram.empty(15, 15);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'narumincho nonogram solver',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('narumincho nonogram solver'),
        ),
        body: Row(children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: NonoGramInput(
                value: _nonogram,
                onChanged: (value) {
                  setState(() {
                    _nonogram = value;
                  });
                },
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Text('結果表示欄'),
          ),
        ]),
      ),
    );
  }
}
