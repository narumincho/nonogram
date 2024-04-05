import 'package:flutter/material.dart';
import 'package:nonogram/widget/nonogram_input.dart';

void main() {
  runApp(const NonogramApp());
}

class NonogramApp extends StatelessWidget {
  const NonogramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'narumincho nonogram solver',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('narumincho nonogram solver'),
        ),
        body: const Row(children: [
          Expanded(flex: 1, child: NonoGramInput()),
          Expanded(flex: 1, child: Text('結果表示欄')),
        ]),
      ),
    );
  }
}
