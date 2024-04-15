import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nonogram/env.dart';
import 'package:nonogram/logic/nonogram.dart';
import 'package:nonogram/widget/nonogram_input.dart';
import 'package:nonogram/widget/size_input.dart';
import 'package:nonogram/widget/step_list.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/link.dart';

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
          actions: [
            Link(
              uri: Uri.parse(commitSha.isEmpty
                  ? 'https://github.com/narumincho/nonogram'
                  : 'https://github.com/narumincho/nonogram/tree/$commitSha'),
              builder: (context, followLink) => IconButton(
                icon: const Icon(SimpleIcons.github),
                onPressed: followLink,
              ),
            )
          ],
        ),
        body: Row(children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: NonoGramInput(
                      value: _nonogram,
                      onChanged: (nonogram) {
                        setState(() {
                          _nonogram = nonogram;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizeInput(
                    columnSize: _nonogram.columnSize,
                    rowSize: _nonogram.rowSize,
                    onColumnSizeChanged: (newColumnSize) {
                      setState(() {
                        _nonogram = _nonogram.setColumnSize(newColumnSize);
                      });
                    },
                    onRowSizeChanged: (newRowSize) {
                      setState(() {
                        _nonogram = _nonogram.setRowSize(newRowSize);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: StepList(value: _nonogram),
          ),
        ]),
      ),
    );
  }
}
