import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sasae_flutter_app/main.dart';
import 'package:sasae_flutter_app/ui/post/post_page.dart';

import 'base.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'View posts',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await loginPrompt(
        tester,
        username: 'bishal',
        password: 'mango321',
      );

      expect(find.byType(PostPage).first, findsOneWidget);
      await tester.pumpAndSettle();

      // final normalPost = find.widgetWithIcon(PostCard, Icons.abc).first;

      // await tester.tap(normalPost);
      // await tester.pumpAndSettle();

      // await tester.drag(find.byType(ListView).first, const Offset(0, -50.0));
      // await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView).first, const Offset(0, 200.0));
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 3));

      // await tester.dragUntilVisible(
      //     normalPost, find.byType(ListView).first, const Offset(0, -50.0));
    },
  );
}
