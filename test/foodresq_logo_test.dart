import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/state/app_state.dart';
import 'package:flutter_application_1/widgets/foodresq_logo.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';
import 'package:flutter_application_1/screens/welcome_role_screen.dart';

void main() {
  testWidgets('FoodResQLogo renders logo image and brand text side-by-side', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: FoodResQLogo(),
          ),
        ),
      ),
    );

    // Verify brand text is rendered
    expect(find.text('FoodResQ'), findsOneWidget);

    // Verify Image.asset is present
    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);

    final imageWidget = tester.widget<Image>(imageFinder);
    expect(imageWidget.fit, equals(BoxFit.contain));
    expect(imageWidget.semanticLabel, equals('FoodResQ Logo'));

    // Verify horizontal layout (Row with CrossAxisAlignment.center)
    final rowFinder = find.byWidgetPredicate((w) => w is Row && w.crossAxisAlignment == CrossAxisAlignment.center);
    expect(rowFinder, findsOneWidget);
  });

  testWidgets('FoodResQLogo respects showText: false for compact headers', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: FoodResQLogo(showText: false),
          ),
        ),
      ),
    );

    // Verify brand text is NOT rendered
    expect(find.text('FoodResQ'), findsNothing);

    // Verify logo image is still present
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('FoodResQLogo renders cleanly across small mobile (320x640) without overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const MaterialApp(
          home: FoodresQWelcomeScreen(),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));

    // Verify branding exists on Home page
    expect(find.byType(FoodResQLogo), findsOneWidget);
    expect(find.text('FoodResQ'), findsOneWidget);

    appState.dispose();
  });

  testWidgets('FoodResQLogo renders on tablet / desktop width (1024x768) responsively', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const MaterialApp(
          home: FoodresQWelcomeScreen(),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(FoodResQLogo), findsOneWidget);
    expect(find.text('FoodResQ'), findsOneWidget);

    appState.dispose();
  });

  testWidgets('WelcomeRoleScreen displays FoodResQLogo in header', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const MaterialApp(
          home: WelcomeRoleScreen(),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(FoodResQLogo), findsOneWidget);
    expect(find.text('How will you use FoodresQ?'), findsOneWidget);

    appState.dispose();
  });
}
