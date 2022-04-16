import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sasae_flutter_app/main.dart';
import 'package:sasae_flutter_app/ui/auth/auth_screen.dart';
import 'package:sasae_flutter_app/ui/post/post_page.dart';

import 'base.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Login',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await loginPrompt(
        tester,
        username: 'bishal',
        password: 'mango321',
      );

      expect(find.byType(PostPage).first, findsOneWidget);
    },
  );

  testWidgets(
    'Logout',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final settingNB = find.byKey(const Key('settingNB'));
      await tester.tap(settingNB);
      await tester.pumpAndSettle();

      final logoutButton = find.byKey(const Key('logoutFAB'));
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog).first, findsOneWidget);

      final confirm = find.widgetWithText(TextButton, 'OK');
      await tester.tap(confirm);
      await tester.pumpAndSettle();

      expect(find.byType(AuthScreen).first, findsOneWidget);
    },
  );

  /* Unable to login cause: 
    - Wrong credentia
    - Connection issue
    - In-active User
  */
  testWidgets(
    'Wrong credential login',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await loginPrompt(
        tester,
        username: 'whoami',
        password: 'whoami',
      );

      await expectLater(find.byType(SnackBar).first, findsOneWidget);
    },
  );
}
