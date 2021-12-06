import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_for_dev/ui/pages/pages.dart';

main() {
  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    const loginPage = MaterialApp(home: LoginPage());

    await tester.pumpWidget(loginPage);

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('E-Mail'),
      matching: find.byType(Text),
    );
    expect(emailTextChildren, findsOneWidget,
        reason: 'When a TextFormField has only one text child, means it '
            'has no errors, since one of the childs is always the label text'
    );

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text)
    );
    expect(
        passwordTextChildren,
        findsOneWidget,
        reason: 'when a TextFormField has only one text child, means it '
            'has no errors, since one of the childs is always the label text'
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });
}
