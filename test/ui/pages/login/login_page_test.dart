import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_for_dev/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

main() {
  late LoginPresenter presenter;
  late StreamController<String> emailErrorController;
  late StreamController<String> passwordErrorController;
  late StreamController<bool> formValidController;

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    formValidController.close();
  });

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    final loginPage = LoginPage(presenter);

    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    formValidController = StreamController<bool>();

    when(() => presenter.emailErrorController)
        .thenAnswer((_) => emailErrorController.stream);

    when(() => presenter.passwordErrorController)
        .thenAnswer((_) => passwordErrorController.stream);

    when(() => presenter.formValidController)
        .thenAnswer((_) => formValidController.stream);

    await tester.pumpWidget(MaterialApp(home: loginPage));
  }

  Finder findTextByLabel(final String of) {
    return find.descendant(
      of: find.bySemanticsLabel(of),
      matching: find.byType(Text),
    );
  }

  Finder findByLabel(final String of) => find.bySemanticsLabel(of);

  ElevatedButton findElevatedButton(WidgetTester tester) =>
      tester.widget<ElevatedButton>(find.byType(ElevatedButton));

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    final Finder emailTextChildren = findTextByLabel('E-Mail');
    expect(
      emailTextChildren,
      findsOneWidget,
      reason: 'When a TextFormField has only one text child, means it '
          'has no errors, since one of the childs is always the label text',
    );

    final Finder passwordTextChildren = findTextByLabel('Senha');
    expect(
      passwordTextChildren,
      findsOneWidget,
      reason: 'when a TextFormField has only one text child, means it '
          'has no errors, since one of the childs is always the label text',
    );

    final buttonEnter = findElevatedButton(tester);
    expect(buttonEnter.onPressed, isNull);
  });

  testWidgets('Should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    final Finder emailTextChildren = findByLabel('E-Mail');
    await tester.enterText(emailTextChildren, email);

    final password = faker.internet.password();
    final Finder passwordTextChildren = findByLabel('Senha');
    await tester.enterText(passwordTextChildren, password);

    verify(() => presenter.validateEmail(email));
  });

  testWidgets('Should presenter error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should presenter no error if email is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    await tester.pump();

    final Finder emailTextChildren = findTextByLabel('E-Mail');
    expect(emailTextChildren, findsOneWidget);
  });

  testWidgets('Should presenter error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add('');
    await tester.pump();

    final Finder emailTextChildren = findTextByLabel('E-Mail');
    expect(emailTextChildren, findsOneWidget);
  });

  testWidgets('Should presenter error if password is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should presenter no error if password is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    await tester.pump();

    final Finder passwordTextChildren = findTextByLabel('Senha');
    expect(passwordTextChildren, findsOneWidget);
  });

  testWidgets('Should presenter error if password is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add('');
    await tester.pump();

    final Finder passwordTextChildren = findTextByLabel('Senha');
    expect(passwordTextChildren, findsOneWidget);
  });

  testWidgets('Should enable button if form is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    formValidController.add(true);
    await tester.pump();

    final buttonEnter = findElevatedButton(tester);
    expect(buttonEnter.onPressed, isNotNull);
  });

  testWidgets('Should enable button if form is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    formValidController.add(false);
    await tester.pump();

    final buttonEnter = findElevatedButton(tester);
    expect(buttonEnter.onPressed, isNull);
  });
}
