import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/state/app_state.dart';

void main() {
  testWidgets('App renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const RescuEatsApp(),
      ),
    );

    expect(find.text('RescuEats'), findsOneWidget);
  });
}
