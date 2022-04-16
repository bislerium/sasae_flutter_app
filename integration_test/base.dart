import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sasae_flutter_app/ui/auth/auth_screen.dart';

Future<void> loginPrompt(WidgetTester tester,
    {required String username, required String password}) async {
  expect(find.byType(AuthScreen).first, findsOneWidget);

  final Finder usernameTF = find.byKey(const Key('usernameATF'));
  final Finder passwordTF = find.byKey(const Key('passwordATF'));
  final Finder loginB = find.byKey(const Key('loginAB'));

  await tester.enterText(usernameTF, username);
  await tester.pumpAndSettle();

  await tester.enterText(passwordTF, password);
  await tester.pumpAndSettle();

  await tester.tap(loginB);
  await tester.pumpAndSettle();
}
