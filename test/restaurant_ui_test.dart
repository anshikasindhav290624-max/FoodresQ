import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/state/app_state.dart';
import 'package:flutter_application_1/screens/restaurant/restaurant_main_screen.dart';

void main() {
  testWidgets('Restaurant interface renders all components following Kirana design system', (WidgetTester tester) async {
    // Set a large enough surface size so all grid elements render cleanly
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const MaterialApp(
          home: RestaurantMainScreen(),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));

    // 1. Verify Header
    expect(find.text('Restaurant'), findsWidgets);
    expect(find.text('Urban Tadka Restaurant 🍽️'), findsOneWidget);
    expect(find.text('Manage food surplus & recover value'), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

    // 2. Verify Hero Banner
    expect(find.text('SURPLUS RECOVERY & REVENUE MANAGEMENT'), findsOneWidget);
    expect(find.text('Urban Tadka Restaurant'), findsWidgets);

    // 3. Verify the 4 Redesigned Compact Metric Cards
    expect(find.text('Revenue Recovered'), findsOneWidget);
    expect(find.text('₹4250'), findsOneWidget);
    expect(find.text('Meals Saved'), findsOneWidget);
    expect(find.text('18'), findsOneWidget);
    expect(find.text('Waste Prevented'), findsOneWidget);
    expect(find.text('24 kg'), findsOneWidget);
    expect(find.text('Orders Served'), findsOneWidget);
    expect(find.text('86'), findsOneWidget);

    // 4. Verify Primary Action CTA Button
    expect(find.text('+ ADD SURPLUS FOOD BATCH'), findsOneWidget);

    // 5. Verify Active Surplus Alert Card
    expect(find.text('📦 ACTIVE SURPLUS & NGO DISPATCH'), findsOneWidget);
    expect(find.text('MANAGE SURPLUS BATCHES NOW'), findsOneWidget);

    // 6. Verify AI Kitchen Waste Forecast Card
    expect(find.text('🤖 AI KITCHEN WASTE FORECAST'), findsOneWidget);
    expect(find.text('PLAN INVENTORY WITH AI'), findsOneWidget);

    // 7. Verify Bottom Navigation
    expect(find.text('HOME'), findsOneWidget);
    expect(find.text('SURPLUS'), findsOneWidget);
    expect(find.text('HISTORY'), findsOneWidget);
    expect(find.text('ANALYTICS'), findsOneWidget);
    expect(find.text('PROFILE'), findsOneWidget);

    // 8. Test Tab Navigation
    await tester.tap(find.text('SURPLUS'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Surplus Management'), findsOneWidget);

    await tester.tap(find.text('ANALYTICS'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Waste Analytics'), findsOneWidget);

    await tester.tap(find.text('HISTORY'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Recovery History'), findsOneWidget);

    await tester.tap(find.text('PROFILE'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Restaurant Profile'), findsOneWidget);

    appState.dispose();
  });

  testWidgets('Restaurant Analytics dashboard renders professional intelligence cards, circular flow, and pipeline', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const MaterialApp(
          home: RestaurantMainScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Navigate to Analytics tab
    await tester.tap(find.text('ANALYTICS'));
    await tester.pump(const Duration(milliseconds: 100));

    // 1. Verify Header & Period Selector
    expect(find.text('Kitchen Waste Intelligence'), findsOneWidget);
    expect(find.text('RESTAURANT INTELLIGENCE'), findsOneWidget);
    expect(find.text('This Month'), findsOneWidget);

    // 2. Verify Hero Banner
    expect(find.text('KITCHEN RECOVERY & CIRCULAR REWARDS'), findsOneWidget);

    // 3. Verify KPI Summary Boxes
    expect(find.text('Cost Saved'), findsOneWidget);
    expect(find.text('Reduction'), findsOneWidget);
    expect(find.text('Meals Saved'), findsOneWidget);
    expect(find.text('Diverted Mass'), findsOneWidget);

    // 4. Verify Circular Rewards Ecosystem
    expect(find.text('FoodResQ Circular Rewards'), findsOneWidget);
    expect(find.text('2450 Points'), findsOneWidget); // Point balance
    expect(find.textContaining('RESCUER'), findsWidgets); // Current Tier
    expect(find.text('POINTS HISTORY'), findsOneWidget);
    expect(find.text('REDEEM ON KIRANA'), findsOneWidget);
    expect(find.textContaining('RESTAURANT'), findsWidgets);
    expect(find.textContaining('NGO'), findsWidgets);
    expect(find.textContaining('REWARDS'), findsWidgets);
    expect(find.textContaining('KIRANA'), findsWidgets);

    // 5. Verify Food Value Recovery Pipeline
    expect(find.text('Food Value Recovery Pipeline'), findsOneWidget);
    expect(find.text('Prepared'), findsOneWidget);
    expect(find.text('Surplus'), findsWidgets);
    expect(find.text('Recovered'), findsWidgets);
    expect(find.text('Prevented'), findsWidgets);

    // 6. Verify Charts and Insights
    expect(find.text('Food Waste & Recovery Trend'), findsOneWidget);
    expect(find.text('Food Recovery Breakdown'), findsOneWidget);
    expect(find.text('Revenue Recovery Progression'), findsOneWidget);
    expect(find.text('Environmental & Resource Conservation'), findsOneWidget);
    expect(find.text('Kitchen Waste Intelligence Insights'), findsOneWidget);

    appState.dispose();
  });

  testWidgets('FoodResQ Reward Points system maintains single source of truth and handles redemption', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();

    // 1. Initial State verification
    expect(appState.restaurantPoints, 2450);
    expect(appState.rewardTierName, 'RESCUER');
    expect(appState.pointHistory.isNotEmpty, true);

    // 2. Perform point redemption for near-expiry offer
    final offer = appState.discountOffers.firstWhere((o) => !o.isPurchased);
    final initialPoints = appState.restaurantPoints;
    final initialHistoryCount = appState.pointHistory.length;

    final result = appState.redeemPointsForKiranaOffer(offer: offer, pointsToUse: 500);
    expect(result['success'], true);
    expect(appState.restaurantPoints, initialPoints - 500);
    expect(appState.pointHistory.length, initialHistoryCount + 1);
    expect(appState.pointHistory.first.isEarned, false);
    expect(appState.pointHistory.first.points, -500);

    // 3. Complete food pickup and distribution by NGO to award points
    final surplus = appState.surplusItems.first;
    final pointsBeforeRescue = appState.restaurantPoints;
    appState.completeFoodPickupAndDistribution(surplus, 35);

    // Surplus meals: 35 meals * 0.4 = 14 kg -> 14 * 10 = 140 points
    expect(appState.restaurantPoints > pointsBeforeRescue, true);
    expect(appState.pointHistory.first.isEarned, true);

    appState.dispose();
  });

  testWidgets('Restaurant interface renders responsively on mobile viewport (400x850) without overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 850);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const MaterialApp(
          home: RestaurantMainScreen(),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Revenue Recovered'), findsOneWidget);
    expect(find.text('+ ADD SURPLUS FOOD BATCH'), findsOneWidget);
    expect(find.text('SURPLUS RECOVERY & REVENUE MANAGEMENT'), findsOneWidget);

    appState.dispose();
  });
}
