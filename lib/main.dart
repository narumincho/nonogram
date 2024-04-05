import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'nonogram',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('nonogram'),
        ),
        body: const Text('イラストロジックを解いてくれるアプリ作りたい'),
      ),
    );
  }
}
