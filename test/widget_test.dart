import 'package:flutter_test/flutter_test.dart';

import 'package:nonogram/main.dart';

void main() {
  testWidgets('visible title', (WidgetTester tester) async {
    await tester.pumpWidget(const NonogramApp());

    expect(find.text('narumincho nonogram solver'), findsAny);
  });
}
