import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const RescuEatsApp(),
    ),
  );
}

class RescuEatsApp extends StatelessWidget {
  const RescuEatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        return MaterialApp(
          title: 'RescuEats — Smart Food & Inventory Recovery',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getThemeData(state.activeRole),
          home: const SplashScreen(),
        );
      },
    );
  }
}
