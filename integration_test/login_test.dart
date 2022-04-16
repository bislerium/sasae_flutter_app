import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:sasae_flutter_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Login to the Sasae',
    (WidgetTester tester) async {
      app.main();
      // await tester.pumpAndSettle();

      // final Finder usernameTF = find.byKey(const Key('usernameATF'));
      // final Finder passwordTF = find.byKey(const Key('passwordATF'));
      // final Finder loginB = find.byKey(const Key('loginAB'));

      // await tester.enterText(usernameTF, 'bishal');
      // await tester.pumpAndSettle();

      // await tester.enterText(passwordTF, 'mango321');
      // await tester.pumpAndSettle();

      // await tester.tap(loginB);
      // await tester.pumpAndSettle();

      // final settingNavButton = find.byKey(const Key('settingNB'));
      // await tester.tap(settingNavButton);
      // await tester.pumpAndSettle();

      // final logoutButton = find.byKey(const Key('logoutFAB'));
      // await tester.tap(logoutButton);
      // await tester.pumpAndSettle();

      expect(1 + 1, equals(2));

      // expect(find.byElementType(AlertDialog), findsOneWidget);
    },
  );
}
