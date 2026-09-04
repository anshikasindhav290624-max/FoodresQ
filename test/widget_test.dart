import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/state/app_state.dart';

void main() {
  testWidgets('App renders landing page directly with Get Started and role cards', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const RescuEatsApp(),
      ),
    );

    // Verify GET STARTED button is present on the initial landing screen
    expect(find.text('GET STARTED'), findsOneWidget);

    // Verify the four role labels are present
    expect(find.text('Restaurant'), findsOneWidget);
    expect(find.text('NGO'), findsOneWidget);
    expect(find.text('Vendor'), findsOneWidget);
    expect(find.text('Kirana'), findsOneWidget);
  });
}
